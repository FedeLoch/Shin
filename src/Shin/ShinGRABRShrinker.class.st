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

	| allCandidates difference |
	
	allCandidates := (reductionStrategy reduce: subTree using: grammar matching: symbol depth: depth) asSet.

	difference := (allCandidates difference: seen) asOrderedCollection.
	difference sort: [ :treeA :treeB | treeA treeSize  < treeB treeSize ]. 
	
	^ difference
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

	| tree found |

	tree := originalTree.
	found := false.

	[tree treeHeight > depth] whileTrue: [
		tree allNodes doWithIndex: [ :subTree :index |
			( subTree isLeaf ) ifFalse: [ | symbol |
				symbol := subTree tag. 
				(self candidates: subTree matching: symbol) do: [ :candidate |
					( seen includes: candidate ) 
					ifFalse: [ 
						seen add: candidate. 
						( candidate treeSize < subTree treeSize) 
						ifTrue: [ | newTree |
							newTree := self replaceSubtreeIn: tree by: candidate index: index.
							self minimizationDone.
							(self triggerBug: newTree upperBound: bound ) ifTrue: [
								tree := newTree.
								found := true.
								self restartDepth.

								^ self minimizeOne: tree upperBound: bound.
							] ifFalse: [ self failedMinimization ]
						]
					]
				]
			]
		].
		found ifFalse: [ depth:= depth + 1 ]
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

	| treeCopy treeToMutate parent |

	treeCopy := self copyTree: tree.
	
	treeToMutate := treeCopy allNodes at: index.
	(treeToMutate isLeaf) ifTrue: [ ^ tree ].
	
	parent := treeToMutate parent. 
	parent ifNil: [ ^ subtrees ].
	
	parent children: ( parent children collect: [ :child |
		(child == treeToMutate) ifTrue: [ subtrees ] ifFalse: [ child ]
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
