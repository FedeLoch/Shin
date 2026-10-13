Class {
	#name : 'ShinSubTreeReducer',
	#superclass : 'ShinVulcanAuxiliaryReducer',
	#instVars : [
		'subtreeShrinker'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'as yet unclassified' }
ShinSubTreeReducer >> grammar: aGrammar [

	super grammar: aGrammar.
	subtreeShrinker grammar: aGrammar 
]

{ #category : 'as yet unclassified' }
ShinSubTreeReducer >> initialize [ 

	super initialize. 
	subtreeShrinker := ShinGRABRShrinker new.
	subtreeShrinker reductionStrategy: ShinSimplifyGrammarSubtreeReducer. "only try to reduce by replacing subtrees with the same symbol"
]

{ #category : 'as yet unclassified' }
ShinSubTreeReducer >> oracle: anOracle [

	super oracle: anOracle.
	subtreeShrinker oracle: anOracle
]

{ #category : 'as yet unclassified' }
ShinSubTreeReducer >> reduce: aTree bound: bound [

	^ self countingCallsOf: subtreeShrinker during: [ subtreeShrinker minimizeOne: aTree upperBound: bound ]
]

{ #category : 'as yet unclassified' }
ShinSubTreeReducer >> resetState [

	super resetState.
	subtreeShrinker resetState
]
