Class {
	#name : 'ShinLazyPerfShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'batchBudget',
		'maxBatchBudget',
		'minBatchBudget'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'private' }
ShinLazyPerfShrinker >> applyRemovals: tree batch: batch [
	"Apply a batch of {nodeIndex -> replacement} removals to a copy of the tree.
	 Each entry is an Association: nodeIndex -> replacementNode.
	 We apply them in reverse index order to preserve index correctness."

	| treeCopy sortedBatch |

	treeCopy := self copyTree: tree.
	batch ifEmpty: [ ^ treeCopy ].

	"Sort by descending index so earlier indices remain valid"
	sortedBatch := batch sorted: [ :a :b | a key > b key ].

	sortedBatch do: [ :assoc | | index replacement allNodes target parent childIndex |
		index := assoc key.
		replacement := assoc value.
		allNodes := treeCopy allNodes.
		
		(index <= allNodes size) ifTrue: [
			target := allNodes at: index.
			parent := target parent.

			parent ifNotNil: [
				childIndex := parent children indexOf: target.
				childIndex > 0 ifTrue: [
					parent replaceChildAt: childIndex with: replacement doCopy
				]
			] ifNil: [
				"Replacing root: return the replacement directly"
				^ replacement doCopy
			]
		]
	].

	^ treeCopy
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> batchBudget [

	^ batchBudget
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> batchBudget: anInteger [

	batchBudget := anInteger
]

{ #category : 'private' }
ShinLazyPerfShrinker >> binarySplit: tree batch: batch upperBound: bound [
	"Split batch in half and validate each half independently.
	 The left half is validated first, and its accepted removals
	 are applied before validating the right half."

	| mid leftBatch rightBatch acceptedLeft treeAfterLeft acceptedRight |

	mid := batch size // 2.
	leftBatch := batch copyFrom: 1 to: mid.
	rightBatch := batch copyFrom: mid + 1 to: batch size.

	"Validate left half"
	acceptedLeft := self binaryValidate: tree batch: leftBatch upperBound: bound.

	"Apply accepted left removals, then validate right half"
	treeAfterLeft := self applyRemovals: tree batch: acceptedLeft.
	acceptedRight := self binaryValidate: treeAfterLeft batch: rightBatch upperBound: bound.

	^ acceptedLeft , acceptedRight
]

{ #category : 'private' }
ShinLazyPerfShrinker >> binaryValidate: tree batch: batch upperBound: bound [
	"Validate a batch of {nodeIndex -> replacement} removals using binary search.
	 Key insight for performance bugs:
	   - Failures are CHEAP (input does not trigger the bug -> program runs fast)
	   - Successes are EXPENSIVE (input still triggers the bug -> program runs slow)
	 So we try all removals at once first: if the oracle says interesting,
	 ONE success call validates the ENTIRE batch.
	 On failure (cheap), we binary-split and recurse."

	| candidate |
	
	batch ifEmpty: [ ^ #() ].

	"Apply ALL removals in the batch at once"
	candidate := self applyRemovals: tree batch: batch.
	self minimizationDone.
	
	(self triggerBug: candidate upperBound: bound) ifTrue: [
		"ONE success call validated the entire batch!"
		^ batch
	].

	"Failure is cheap, so we can afford to probe further"
	self failedMinimization.

	batch size = 1 ifTrue: [
		"This single removal breaks the property"
		^ #()
	].

	"Binary split and recurse"
	^ self binarySplit: tree batch: batch upperBound: bound
]

{ #category : 'private' }
ShinLazyPerfShrinker >> collectBatch: tree [
	"Collect a batch of compatible (non-overlapping) subtree removals.
	 Each removal replaces a node with its shortest grammar derivation.
	 Nodes are prioritized by subtree size (largest first, like Perses)
	 to maximize the amount of input removed per oracle call.
	 Returns a collection of Associations: nodeIndex -> replacementNode."

	| allNodes sortedIndices batch removedIndices |

	allNodes := tree allNodes.
	
	"Sort node indices by subtree size descending (largest subtrees first)"
	sortedIndices := (1 to: allNodes size) asArray sorted: [ :a :b |
		(allNodes at: a) treeSize > (allNodes at: b) treeSize
	].

	batch := OrderedCollection new.
	removedIndices := Set new.

	sortedIndices do: [ :index | | node replacement |
		(batch size >= batchBudget) ifTrue: [ ^ batch asArray ].

		node := allNodes at: index.

		"Skip leaves and the root"
		(node isLeaf or: [ node parent isNil ]) ifFalse: [
			"Skip nodes already covered by a batched ancestor/descendant"
			(removedIndices includes: index) ifFalse: [
				(self hasRemovedAncestor: node in: removedIndices in: allNodes) ifFalse: [
					replacement := self minimized: node.
				
					"Only include if replacement is strictly smaller"
					(replacement notNil and: [ replacement treeSize < node treeSize ]) ifTrue: [
						batch add: index -> replacement.
						removedIndices add: index.
						"Mark all descendants as covered"
						self markDescendants: node startingAt: index in: allNodes into: removedIndices
					]
				]
			]
		]
	].

	^ batch asArray
]

{ #category : 'private' }
ShinLazyPerfShrinker >> hasRemovedAncestor: node in: removedIndices in: allNodes [
	"Walk up from node to root, checking if any ancestor is in removedIndices."

	| current |
	
	current := node parent.
	[ current notNil ] whileTrue: [
		| idx |
		idx := allNodes indexOf: current.
		(idx > 0 and: [ removedIndices includes: idx ]) ifTrue: [ ^ true ].
		current := current parent
	].

	^ false
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> initialize [

	super initialize.
	batchBudget := 8.
	maxBatchBudget := 64.
	minBatchBudget := 1
]

{ #category : 'private' }
ShinLazyPerfShrinker >> markDescendants: node startingAt: index in: allNodes into: removedIndices [
	"Mark all descendants of node as covered so they are not batched separately."

	node allNodes do: [ :descendant |
		| idx |
		idx := allNodes indexOf: descendant.
		(idx > 0 and: [ idx ~= index ]) ifTrue: [
			removedIndices add: idx
		]
	]
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> maxBatchBudget: anInteger [

	maxBatchBudget := anInteger
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> minBatchBudget: anInteger [

	minBatchBudget := anInteger
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> minimizeOne: originalTree upperBound: bound [
	"LazyPerf main loop:
	 1. Collect batches of compatible (non-overlapping) subtree removals,
	    prioritized by subtree size (largest first).
	 2. Validate each batch using binary search, amortizing the expensive
	    success oracle calls across multiple removals.
	 3. Adaptively tune the batch budget based on acceptance rate.
	 
	 This design exploits the cost asymmetry of performance oracles:
	 failures (uninteresting) are fast, successes (interesting) are slow.
	 By batching removals and using binary search validation, we pay for
	 fewer expensive success calls while using cheap failure calls to probe."

	| tree progress |

	tree := self tree: originalTree asInput.
	tree ifNil: [ ^ originalTree ].
	progress := true.

	[ progress ] whileTrue: [
		| batch accepted |
		progress := false.

		batch := self collectBatch: tree.
		batch ifNotEmpty: [
			"Phase: Binary validation of the batch"
			accepted := self binaryValidate: tree batch: batch upperBound: bound.
			
			accepted ifNotEmpty: [
				tree := self applyRemovals: tree batch: accepted.
				progress := true.

				"Adaptive budget tuning"
				self tuneBudget: accepted size against: batch size
			].

			"If nothing was accepted from a non-empty batch, try smaller batches"
			(accepted isEmpty and: [ batchBudget > minBatchBudget ]) ifTrue: [
				batchBudget := (batchBudget // 2) max: minBatchBudget.
				progress := true "retry with smaller budget"
			]
		]
	].

	^ tree
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]

{ #category : 'private' }
ShinLazyPerfShrinker >> tuneBudget: acceptedCount against: batchCount [
	"Adaptively tune the batch budget based on how many removals were accepted.
	 High acceptance rate -> be more aggressive (larger batches).
	 Low acceptance rate -> be more conservative (smaller batches)."

	| acceptanceRate |
	
	acceptanceRate := acceptedCount / batchCount.

	acceptanceRate > (4/5) ifTrue: [
		"Most removals worked, increase aggressiveness"
		batchBudget := (batchBudget * 2) min: maxBatchBudget
	].
	acceptanceRate < (1/5) ifTrue: [
		"Few removals worked, decrease aggressiveness"
		batchBudget := (batchBudget // 2) max: minBatchBudget
	]
]
