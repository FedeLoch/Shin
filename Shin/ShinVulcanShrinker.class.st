Class {
	#name : 'ShinVulcanShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'mainReducer',
		'auxiliaryReducers',
		'limit',
		'windowSize'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinVulcanShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'accessing' }
ShinVulcanShrinker >> auxiliaryReducers [ 

	^auxiliaryReducers 
]

{ #category : 'accessing' }
ShinVulcanShrinker >> grammar: aGrammar [

	super grammar: aGrammar. 
	mainReducer grammar: aGrammar.
	auxiliaryReducers do: [ :reducer |
		reducer grammar: aGrammar ]
]

{ #category : 'accessing' }
ShinVulcanShrinker >> identifierReplacer [ 
	
	^ self auxiliaryReducers at: 1
]

{ #category : 'accessing' }
ShinVulcanShrinker >> initialize [

	super initialize.
	
	maxIterations := 1.
	windowSize := 4. 
	
	mainReducer := ShinHDDShrinker new.
	auxiliaryReducers := { 
		ShinIdentifierReplacement new. 
		ShinSubTreeReducer new.
		ShinTreeBasedLEE new }
]

{ #category : 'accessing' }
ShinVulcanShrinker >> mainReducer: aReducer [

	mainReducer := aReducer.
	mainReducer grammar: grammar. 
]

{ #category : 'shrinking' }
ShinVulcanShrinker >> minimizeOne: originalTree upperBound: bound [

	| minimumInput index |
	
	minimumInput := self copyTree: originalTree.
	index := 1.
	
	[ index <= auxiliaryReducers size ] whileTrue: [
		| startingSize result |
		startingSize := minimumInput treeSize. 
		
		"Main reducer"
		minimumInput := self reduceMain: minimumInput bound: bound.
		self minimizationDone.
		
		"Auxiliary reducers"
		result := self runAuxiliary: minimumInput startingAt: index  bound: bound.
		minimumInput := result key.
		index := result value.  
		
		"if we don't find smaller input, we stop"
		(minimumInput treeSize = startingSize ) ifTrue: [ ^ minimumInput ].
	].

	auxiliaryReducers do: [ :auxiliar | self minimizationDone: (auxiliar getMinimizationDone). self failedMinimization: (auxiliar getFailedMinimization) ].
	^ minimumInput
]

{ #category : 'accessing' }
ShinVulcanShrinker >> oracle: aOracle [

	super oracle: aOracle. 
	mainReducer oracle: aOracle.
	auxiliaryReducers do: [ :reducer |
		reducer oracle: aOracle ]
]

{ #category : 'accessing' }
ShinVulcanShrinker >> reduceAuxiliary: reducer on: aTree bound: bound [

	| candidate prevSize |
	
	prevSize := aTree treeSize.
	candidate := reducer reduce: aTree bound: bound.
	self minimizationDone.
	
	^ (candidate treeSize < prevSize ) ifTrue: [ candidate ] ifFalse: [ self failedMinimization. aTree ]
]

{ #category : 'accessing' }
ShinVulcanShrinker >> reduceMain: aTree bound: bound [

	^ mainReducer minimizeOne: aTree upperBound: bound 
]

{ #category : 'accessing' }
ShinVulcanShrinker >> runAuxiliary: aTree startingAt: aIndex bound: bound [

	| currentTree index haveReduce|
	
	currentTree := aTree.
	index := aIndex.
	haveReduce := false.
	
	[  (index <= auxiliaryReducers size) and: [ haveReduce not ] ] whileTrue: [ 
		| reducer candidate prevSize |
		reducer := auxiliaryReducers at: index. 
		prevSize := currentTree treeSize.
		candidate := self reduceAuxiliary: reducer on: currentTree bound: bound.
		
		(candidate treeSize < prevSize ) ifTrue: [ 
			currentTree := candidate.
			haveReduce := true.
		] ifFalse: [ 
			index := index + 1
		]
	].

	^ currentTree -> index "we return the new tree and the new index"
]

{ #category : 'accessing' }
ShinVulcanShrinker >> setWindowSize: aSize [

	windowSize := aSize.
	(auxiliaryReducers at:3) windowSize: aSize
]

{ #category : 'accessing' }
ShinVulcanShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
	
]

{ #category : 'accessing' }
ShinVulcanShrinker >> subtreeReducer [ 
	
	^ self auxiliaryReducers at: 2
]

{ #category : 'accessing' }
ShinVulcanShrinker >> treeBasedLee [ 
	
	^ self auxiliaryReducers at: 3
]
