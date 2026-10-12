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
	
	mainReducer := "ShinHDDShrinker"ShinHDDPaperShrinker new.
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
		startingSize := self sizeOf: minimumInput. 
		
		"Main reducer"
		minimumInput := self reduceMain: minimumInput bound: bound.
		
		"Auxiliary reducers"
		result := self runAuxiliary: minimumInput startingAt: index  bound: bound.
		minimumInput := result key.
		index := result value.  
		
		"if we don't find smaller input, we stop"
		((self sizeOf: minimumInput) = startingSize ) ifTrue: [ ^ minimumInput ].
	].

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
	
	"sizes are recomputed: the cached treeSize is not reliable after in-place edits"
	prevSize := self sizeOf: aTree.
	candidate := self countingCallsOf: reducer during: [ reducer reduce: aTree bound: bound ].
	
	^ ((self sizeOf: candidate) < prevSize ) ifTrue: [ candidate ] ifFalse: [ aTree ]
]

{ #category : 'accessing' }
ShinVulcanShrinker >> reduceMain: aTree bound: bound [

	^ self countingCallsOf: mainReducer during: [ mainReducer minimizeOne: aTree upperBound: bound ]
]

{ #category : 'shrinking' }
ShinVulcanShrinker >> resetState [

	super resetState.
	mainReducer resetState.
	auxiliaryReducers do: [ :reducer | reducer resetState ]
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
		prevSize := self sizeOf: currentTree.
		candidate := self reduceAuxiliary: reducer on: currentTree bound: bound.
		
		((self sizeOf: candidate) < prevSize ) ifTrue: [ 
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
