Class {
	#name : 'ShinLazyPerfShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'batchBudget',
		'maxBatchBudget',
		'minBatchBudget',
		'rejected',
		'initialBatchBudget'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'private' }
ShinLazyPerfShrinker >> applyRemovals: batch [
	"Apply a batch of {node -> replacement} removals in place.
	 Nodes of a batch never overlap, so replacing one does not affect the others.
	 Answer the undo information: {parent . index . originalNode} triples."

	^ batch collect: [ :assoc | | node parent index |
		node := assoc key.
		parent := node parent.
		index := parent children identityIndexOf: node.
		parent replaceChildAt: index with: assoc value.
		{ parent . index . node } ]
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> batchBudget [

	^ batchBudget
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> batchBudget: anInteger [

	initialBatchBudget := anInteger.
	batchBudget := anInteger
]

{ #category : 'private' }
ShinLazyPerfShrinker >> binarySplit: tree batch: batch upperBound: bound [
	"Split batch in half and validate each half independently.
	 The left half is validated first and its accepted removals stay applied,
	 so the right half is validated on top of them, in the real current state."

	| mid acceptedLeft acceptedRight |

	mid := batch size // 2.
	acceptedLeft := self binaryValidate: tree batch: (batch copyFrom: 1 to: mid) upperBound: bound.
	acceptedRight := self binaryValidate: tree batch: (batch copyFrom: mid + 1 to: batch size) upperBound: bound.

	^ acceptedLeft , acceptedRight
]

{ #category : 'private' }
ShinLazyPerfShrinker >> binaryValidate: tree batch: batch upperBound: bound [
	"Validate a batch of {node -> replacement} removals using binary search.
	 Key insight for performance bugs:
	   - Failures are CHEAP (input does not trigger the bug -> program runs fast)
	   - Successes are EXPENSIVE (input still triggers the bug -> program runs slow)
	 So we try all removals at once first: if the oracle says interesting,
	 ONE success call validates the ENTIRE batch.
	 On failure (cheap), we binary-split and recurse.
	 Accepted removals stay applied to tree, rejected ones are undone."

	| undo |

	batch ifEmpty: [ ^ #() ].

	"Apply ALL removals in the batch at once"
	undo := self applyRemovals: batch.
	self minimizationDone.

	(self triggerBug: tree upperBound: bound) ifTrue: [
		"ONE success call validated the entire batch!"
		^ batch
	].

	"Failure is cheap, so we can afford to probe further"
	self failedMinimization.
	self undoRemovals: undo.

	batch size = 1 ifTrue: [
		"This single removal breaks the property, its descendants may still be reduced"
		rejected add: batch first key.
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
	 Nodes whose removal was already rejected do not cover their descendants.
	 Returns a collection of Associations: node -> replacementNode."

	| sortedNodes batch selected |

	sortedNodes := tree allNodes asArray sorted: [ :a :b | a treeSize > b treeSize ].

	batch := OrderedCollection new.
	selected := IdentitySet new.

	sortedNodes do: [ :node |
		(batch size >= batchBudget) ifTrue: [ ^ batch asArray ].

		"Skip leaves, the root and already rejected nodes"
		(node isLeaf or: [ node parent isNil or: [ rejected includes: node ] ]) ifFalse: [
			"Skip nodes overlapping a batched ancestor"
			(self hasAncestor: node in: selected) ifFalse: [ | replacement |
				replacement := self minimized: node.

				"Only include if replacement is strictly smaller"
				(replacement notNil and: [ replacement treeSize < node treeSize ])
					ifTrue: [
						batch add: node -> replacement.
						selected add: node ]
					ifFalse: [ rejected add: node ]
			]
		]
	].

	^ batch asArray
]

{ #category : 'private' }
ShinLazyPerfShrinker >> hasAncestor: node in: selected [
	"Walk up from node to root, checking if any ancestor is already in the batch.
	 Nodes are sorted by decreasing size, so a batched descendant cannot come first."

	| current |

	current := node parent.
	[ current notNil ] whileTrue: [
		(selected includes: current) ifTrue: [ ^ true ].
		current := current parent
	].

	^ false
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> initialize [

	super initialize.
	self batchBudget: 8.
	maxBatchBudget := 64.
	minBatchBudget := 1
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
	 fewer expensive success calls while using cheap failure calls to probe.

	 Every batch either shrinks the tree or rejects at least one node,
	 so the loop terminates."

	| tree batch |

	tree := self tree: originalTree asInput.
	tree ifNil: [ ^ originalTree ].
	rejected := IdentitySet new.

	[ (batch := self collectBatch: tree) notEmpty ] whileTrue: [ | accepted |
		accepted := self binaryValidate: tree batch: batch upperBound: bound.
		self tuneBudget: accepted size against: batch size
	].

	^ tree
]

{ #category : 'shrinking' }
ShinLazyPerfShrinker >> resetState [

	"the budget adapts during a run, every run starts from the configured one"
	super resetState.
	batchBudget := initialBatchBudget
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

{ #category : 'private' }
ShinLazyPerfShrinker >> undoRemovals: undo [

	undo reverseDo: [ :each |
		each first replaceChildAt: each second with: each third ]
]
