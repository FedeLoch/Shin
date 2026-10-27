"
Behavior specific to the minimization described in the Nautilus paper (NDSS 2019, section IV-B):
a subtree minimization pass followed by a recursive minimization pass.
"
Class {
	#name : 'ShinNautilusPaperShrinkerTest',
	#superclass : 'ShinReductionShrinkerTest',
	#instVars : [
		'grammar',
		'calls'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'helpers' }
ShinNautilusPaperShrinkerTest >> parse: aString [

	^ GncGenericGrammarParser parse: aString from: grammar
]

{ #category : 'running' }
ShinNautilusPaperShrinkerTest >> setUp [

	super setUp.
	grammar := AritExpressionGrammar new
]

{ #category : 'helpers' }
ShinNautilusPaperShrinkerTest >> shrinker: block [

	^ ShinNautilusPaperShrinker new
		  grammar: grammar;
		  oracle: (self oracleByBlock: [ :input | calls := calls + 1. block value: input ]);
		  yourself
]

{ #category : 'tests' }
ShinNautilusPaperShrinkerTest >> testAlreadyMinimalSubtreesAreNotTested [

	| shrinker |
	calls := 0.
	shrinker := self shrinker: [ :s | s includes: $3 ].

	"every subtree of '3' is already the smallest derivation of its symbol, and there is no recursion"
	self assert: (shrinker shrink: '3') equals: '3'.
	self assert: shrinker getMinimizationDone equals: 0
]

{ #category : 'tests' }
ShinNautilusPaperShrinkerTest >> testRecursiveMinimizationReachesAncestorsThroughOtherSymbols [

	| result |
	calls := 0.
	"the inner Expr of '((1+2))' is below Term and Factor: the nearest Expr ancestor is several levels up"
	result := (self shrinker: [ :s | s includes: $+ ]) shrink: '((1+2))'.

	self assert: result equals: '1+2'
]

{ #category : 'tests' }
ShinNautilusPaperShrinkerTest >> testRecursiveMinimizationReplacesAnExpressionByASubexpression [

	calls := 0.
	"the paper's example IV.3: an addition replaced by one of its operands"
	self assert: ((self shrinker: [ :s | s includes: $3 ]) shrink: '1+3') equals: '3'
]

{ #category : 'tests' }
ShinNautilusPaperShrinkerTest >> testReplacementsKeepTheTreeConsistent [

	| tree |
	calls := 0.
	tree := (self shrinker: [ :s | (s includes: $3) and: [ s includes: $7 ] ])
		        minimizeOne: (self parse: '1+(2*3)+4*(5+(6*7))+8')
		        upperBound: true.

	self assert: tree treeSize equals: tree allNodes size.
	self assert: (tree allNodes allSatisfy: [ :node |
			 node == tree or: [ node parent children anySatisfy: [ :child | child == node ] ] ]).
	self assert: (GncGenericGrammarParser accept: tree asInput from: grammar)
]

{ #category : 'tests' }
ShinNautilusPaperShrinkerTest >> testSubtreeMinimizationCanReplaceTheRoot [

	calls := 0.
	"the root is visited first: its smallest derivation is a single digit"
	self assert: ((self shrinker: [ :s | s notEmpty ]) shrink: '12+34*(5+6)') size equals: 1
]

{ #category : 'tests' }
ShinNautilusPaperShrinkerTest >> testSubtreeMinimizationReplacesBySmallestDerivation [

	| result |
	calls := 0.
	"the number 123 is replaced by the smallest derivation of its Term: a single digit"
	result := (self shrinker: [ :s | s includes: $+ ]) shrink: '123+4'.

	self assert: result size equals: 3.
	self assert: (result at: 2) equals: $+
]

{ #category : 'tests' }
ShinNautilusPaperShrinkerTest >> testSubtreePassRunsBeforeTheRecursivePass [

	| inputs firstRecursiveCandidate |
	inputs := OrderedCollection new.
	calls := 0.
	(self shrinker: [ :s | inputs add: s. s includes: $+ ]) shrink: '(12+34)'.

	"the recursive pass hoists the inner Expr, producing an input without parentheses;
	it only happens after every subtree has been tried (and shrunk) by the first pass"
	firstRecursiveCandidate := inputs detect: [ :s | (s includes: $+) and: [ (s includes: $() not ] ] ifNone: [ nil ].
	self assert: firstRecursiveCandidate notNil.
	"both numbers were already reduced to one digit when the parentheses were removed"
	self assert: (firstRecursiveCandidate select: #isDigit) size equals: 2
]
