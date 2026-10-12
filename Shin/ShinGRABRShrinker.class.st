Class {
	#name : 'ShinGRABRShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'reductionStrategy',
		'seen',
		'depth'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinGRABRShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
ShinGRABRShrinker >> candidates: subTree matching: symbol [

	| allCandidates |
	
	allCandidates := (reductionStrategy reduce: subTree using: grammar matching: symbol depth: depth) asOrderedCollection.
	allCandidates sort: [ :treeA :treeB | treeA treeSize  < treeB treeSize ]. 
	
	^ allCandidates
]

{ #category : 'shrinking' }
ShinGRABRShrinker >> initialize [ 

	super initialize.
	seen := Set new.
	reductionStrategy := ShinSimplifyGrammarBoth.
	depth := 0.
	
]

{ #category : 'shrinking' }
ShinGRABRShrinker >> minimizeOne: originalTree upperBound: bound [

	| tree |

	"Every call starts from depth 0 with a fresh memo: the state of a previous call
	(or of a previous tree) must not leak into this one."
	tree := originalTree.
	self restartDepth.
	seen := Set new.

	[tree treeHeight > depth] whileTrue: [
		tree allNodes doWithIndex: [ :subTree :index |
			( subTree isLeaf ) ifFalse: [ | symbol |
				symbol := subTree tag. 
				(self candidates: subTree matching: symbol) do: [ :candidate | | key |
					"the same replacement text at the same position is tested only once per tree"
					key := index -> candidate asInput.
					( seen includes: key ) 
					ifFalse: [ 
						seen add: key. 
						( candidate treeSize < subTree treeSize) 
						ifTrue: [ | newTree |
							newTree := self replaceSubtreeIn: tree by: candidate index: index.
							self minimizationDone.
							(self triggerBug: newTree upperBound: bound ) ifTrue: [
								^ self minimizeOne: newTree upperBound: bound.
							] ifFalse: [ self failedMinimization ]
						]
					]
				]
			]
		].
		depth := depth + 1
	].

	^ tree
]

{ #category : 'accessing' }
ShinGRABRShrinker >> reductionStrategy [

	^ reductionStrategy
]

{ #category : 'accessing' }
ShinGRABRShrinker >> reductionStrategy: aStrategy [

	reductionStrategy := aStrategy
]

{ #category : 'copying' }
ShinGRABRShrinker >> replaceSubtreeIn: tree by: subtrees index: index [

	| treeCopy treeToMutate parent replacement |

	treeCopy := self copyTree: tree.
	
	treeToMutate := treeCopy allNodes at: index.
	(treeToMutate isLeaf) ifTrue: [ ^ tree ].
	
	"Insert a copy: candidates can be nodes of the original tree, which must stay untouched
	if the reduction is rejected"
	replacement := self copyTree: subtrees.
	
	parent := treeToMutate parent. 
	parent ifNil: [ ^ replacement ].
	
	self setChildrenOf: parent to: ( parent children collect: [ :child |
		(child == treeToMutate) ifTrue: [ replacement ] ifFalse: [ child ]
	]).
	
	^ treeCopy
]

{ #category : 'shrinking' }
ShinGRABRShrinker >> restartDepth [
	
	depth := 0
]

{ #category : 'shrinking' }
ShinGRABRShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
	
]
