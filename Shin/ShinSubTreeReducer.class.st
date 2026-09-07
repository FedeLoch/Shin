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
ShinSubTreeReducer >> reduce: aTree bound: bound [

	| minimizedTree |
	
	minimizedTree := subtreeShrinker minimizeOne: aTree upperBound: bound.
	self minimizationDone: (subtreeShrinker getMinimizationDone).
	self failedMinimization: (subtreeShrinker getFailedMinimization).
	
	^ minimizedTree
]
