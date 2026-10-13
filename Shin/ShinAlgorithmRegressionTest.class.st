"
Regression tests for algorithm-specific bugs that the property suites
(ShinFlatReducerPropertyTest, ShinGrammarReducerPropertyTest) do not isolate.
"
Class {
	#name : 'ShinAlgorithmRegressionTest',
	#superclass : 'ShinReductionShrinkerTest',
	#instVars : [
		'grammar'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'helpers' }
ShinAlgorithmRegressionTest >> parse: aString [

	^ GncGenericGrammarParser parse: aString from: grammar
]

{ #category : 'running' }
ShinAlgorithmRegressionTest >> setUp [

	super setUp.
	grammar := AritExpressionGrammar new
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testAlternateReductionKeepsTerminals [

	| factor candidates |
	factor := (self parse: '(1+2)') allNodes detect: [ :node | node tag asString = 'Factor' ].

	candidates := (ShinSimplifyGrammarAlternateReduction alternateReduction: factor using: grammar matchingWith: 'Factor') collect: #asInput.

	"'(' Expr ')' must keep its parentheses"
	self assert: (candidates includes: '(2)').
	self deny: (candidates includes: '1+2')
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testGRABRDoesNotMutateTheOriginalTree [

	| shrinker tree |
	shrinker := ShinGRABRShrinker new grammar: grammar; oracle: (self oracleByBlock: [ :input | input includes: $3 ]); yourself.
	tree := self parse: '1+(2*3)'.

	shrinker minimizeOne: tree upperBound: true.

	self assert: tree asInput equals: '1+(2*3)'.
	self assert: (tree allNodes allSatisfy: [ :node | node == tree or: [ node parent children includes: node ] ])
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testGRABRMinimizeOneCanBeCalledTwice [

	| shrinker first second |
	shrinker := ShinGRABRShrinker new grammar: grammar; oracle: (self oracleByBlock: [ :input | input includes: $3 ]); yourself.

	first := shrinker minimizeOne: (self parse: '1+(2*3)') upperBound: true.
	second := shrinker minimizeOne: (self parse: '1+(2*3)') upperBound: true.

	self assert: first asInput equals: '3'.
	self assert: second asInput equals: '3'
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testLazyPerfReducesBelowARejectedNode [

	| result |
	"Replacing the whole expression loses the $3, nested nodes must still be tried"
	result := (ShinLazyPerfShrinker new grammar: grammar; oracle: (self oracleByBlock: [ :input | input includes: $3 ]); yourself)
		          shrink: '1+(2*3)+4*(5+(6*7))+8'.

	self assert: (result includes: $3).
	self assert: result size < '1+(2*3)+4*(5+(6*7))+8' size
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testMinimizedNodeIsTheSmallestDerivationOfItsSymbol [

	| shrinker |
	shrinker := ShinNautilusShrinker new grammar: grammar; yourself.

	((self parse: '12+(3*45)') allNodes reject: #isLeaf) do: [ :node | | minimal |
		minimal := shrinker minimized: node.
		self assert: minimal tag equals: node tag.
		self assert: minimal treeSize equals: (shrinker nonTerminalNamed: node tag) minSize ]
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testNautilusMinimizesIdenticalSubtreesAtDifferentPositions [

	| result |
	result := (ShinNautilusShrinker new grammar: grammar; oracle: (self oracleByBlock: [ :input | input includes: $3 ]); yourself)
		          shrink: '11+11+3'.

	self deny: (result includesSubstring: '11')
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testProbDDDoesNotLoopWhenAnElementBecomesCertain [

	| shrinker |
	shrinker := ShinProbDDShrinker new oracle: (self oracleByBlock: [ :input | input includes: $b ]); yourself.

	self assert: (shrinker shrink: 'abcd') equals: 'b'
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testSubTreeReducerUsesTheOracleGivenToVulcan [

	| vulcan reduced |
	vulcan := ShinVulcanShrinker new grammar: grammar; oracle: (self oracleByBlock: [ :input | input includes: $3 ]); yourself.

	reduced := vulcan subtreeReducer reduce: (self parse: '1+(2*3)') bound: true.

	self assert: reduced asInput equals: '3'
]

{ #category : 'tests' }
ShinAlgorithmRegressionTest >> testWDDminComplementRemovesThePartition [

	| shrinker inputs |
	inputs := OrderedCollection new.
	shrinker := ShinWDDminShrinker new oracle: (self oracleByBlock: [ :input | inputs add: input. (input includes: $a) and: [ input includes: $h ] ]); yourself.

	shrinker shrink: 'abcdefgh'.

	"the first evaluation computes the baseline, after it a complement test always removes
	something, so the original input is never tested again as is"
	self deny: (inputs allButFirst includes: 'abcdefgh')
]
