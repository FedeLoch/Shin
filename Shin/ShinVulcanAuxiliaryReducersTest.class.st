Class {
	#name : 'ShinVulcanAuxiliaryReducersTest',
	#superclass : 'ShinReductionShrinkerTest',
	#instVars : [
		'grammar'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'helpers' }
ShinVulcanAuxiliaryReducersTest >> parse: aString [

	^ GncGenericGrammarParser parse: aString from: grammar
]

{ #category : 'helpers' }
ShinVulcanAuxiliaryReducersTest >> reducer: aReducerClass oracle: block [

	^ aReducerClass new
		  grammar: grammar;
		  oracle: (self oracleByBlock: block);
		  yourself
]

{ #category : 'running' }
ShinVulcanAuxiliaryReducersTest >> setUp [

	super setUp.
	grammar := AritExpressionGrammar new
]

{ #category : 'tests' }
ShinVulcanAuxiliaryReducersTest >> testIdentifierReplacementKeepsTokensWhenTheBugDisappears [

	| reducer |
	reducer := self reducer: ShinIdentifierReplacement oracle: [ :s | (s includes: $1) and: [ s includes: $2 ] ].

	self assert: (reducer reduce: (self parse: '1+2') bound: true) asInput equals: '1+2'.
	self assert: reducer getMinimizationDone equals: reducer getFailedMinimization
]

{ #category : 'tests' }
ShinVulcanAuxiliaryReducersTest >> testIdentifierReplacementOnlyUsesTokensOfTheSameSymbol [

	| result |
	result := (self reducer: ShinIdentifierReplacement oracle: [ :s | s includes: $+ ])
		          reduce: (self parse: '1+2*3') bound: true.

	"digits may be unified, operators keep their own symbol"
	self assert: (GncGenericGrammarParser accept: result asInput from: grammar).
	self assert: (result asInput includes: $+).
	self assert: (result asInput select: #isDigit) asSet size equals: 1
]

{ #category : 'tests' }
ShinVulcanAuxiliaryReducersTest >> testIdentifierReplacementUnifiesTokens [

	| result |
	result := (self reducer: ShinIdentifierReplacement oracle: [ :s | s includes: $+ ])
		          reduce: (self parse: '1+2') bound: true.

	self assert: result asInput first equals: result asInput last
]

{ #category : 'tests' }
ShinVulcanAuxiliaryReducersTest >> testSubTreeReducerCountsItsOracleCalls [

	| reducer calls |
	calls := 0.
	reducer := self reducer: ShinSubTreeReducer oracle: [ :s | calls := calls + 1. s includes: $3 ].

	reducer reduce: (self parse: '1+(2*3)') bound: true.
	reducer reduce: (self parse: '4+(5*3)') bound: true.

	self assert: reducer getMinimizationDone equals: calls
]

{ #category : 'tests' }
ShinVulcanAuxiliaryReducersTest >> testSubTreeReducerReplacesBySubtrees [

	| result |
	result := (self reducer: ShinSubTreeReducer oracle: [ :s | s includes: $3 ])
		          reduce: (self parse: '1+(2*3)') bound: true.

	self assert: result asInput equals: '3'
]

{ #category : 'tests' }
ShinVulcanAuxiliaryReducersTest >> testTreeBasedLEEDoesNothingOnSmallTrees [

	| reducer |
	reducer := self reducer: ShinTreeBasedLEE oracle: [ :s | s includes: $3 ].
	reducer windowSize: 50.

	self assert: (reducer reduce: (self parse: '1+3') bound: true) asInput equals: '1+3'.
	self assert: reducer getMinimizationDone equals: 0
]

{ #category : 'tests' }
ShinVulcanAuxiliaryReducersTest >> testTreeBasedLEEKeepsTheBug [

	| reducer input result |
	reducer := self reducer: ShinTreeBasedLEE oracle: [ :s | s includes: $3 ].
	input := '1+(2*3)+4*(5+(6*7))+8'.

	result := reducer reduce: (self parse: input) bound: true.

	self assert: (result asInput includes: $3).
	self assert: result asInput size < input size.
	self assert: (GncGenericGrammarParser accept: result asInput from: grammar).
	self assert: result treeSize equals: result allNodes size
]
