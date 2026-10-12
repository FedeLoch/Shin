"
Properties every grammar-based reducer must satisfy on the arithmetic expression grammar.
Each test runs once per reducer listed in #testParameters.
"
Class {
	#name : 'ShinGrammarReducerPropertyTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'shrinkerClass',
		'grammar',
		'calls'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'building suites' }
ShinGrammarReducerPropertyTest class >> testParameters [

	^ ParametrizedTestMatrix new
		  forSelector: #shrinkerClass
		  addOptions: {
				  ShinHDDShrinker.
				  ShinHDDPaperShrinker.
				  ShinGRABRShrinker.
				  ShinNautilusShrinker.
				  ShinVulcanShrinker.
				  ShinSADDminShrinker.
				  ShinSAProbDDShrinker.
				  ShinSADDminHDDShrinker.
				  ShinSAProbDDHDDShrinker.
				  ShinLazyPerfShrinker };
		  yourself
]

{ #category : 'helpers' }
ShinGrammarReducerPropertyTest >> cases [

	"input -> oracle"
	^ {
		  '1+3' -> [ :s | s includes: $3 ].
		  '1+(2*3)' -> [ :s | s includes: $3 ].
		  '1+(2*3)+4*(5+(6*7))+8' -> [ :s | (s includes: $3) and: [ s includes: $7 ] ].
		  '(((1+2)))' -> [ :s | s includes: $( ].
		  '9*8-7/6+5' -> [ :s | s includes: $/ ].
		  '12345+678' -> [ :s | s includes: $5 ] }
]

{ #category : 'helpers' }
ShinGrammarReducerPropertyTest >> countingOracle: block [

	calls := 0.
	^ ShinBooleanInputOracle from: [ :input |
		calls := calls + 1.
		block value: input ]
]

{ #category : 'helpers' }
ShinGrammarReducerPropertyTest >> newShrinker: block [

	^ shrinkerClass new
		  grammar: grammar;
		  oracle: (ShinBooleanInputOracle from: block);
		  yourself
]

{ #category : 'helpers' }
ShinGrammarReducerPropertyTest >> parse: aString [

	^ GncGenericGrammarParser parse: aString from: grammar
]

{ #category : 'running' }
ShinGrammarReducerPropertyTest >> setUp [

	super setUp.
	self timeLimit: 2 minutes.
	grammar := AritExpressionGrammar new
]

{ #category : 'accessing' }
ShinGrammarReducerPropertyTest >> shrinkerClass [

	^ shrinkerClass
]

{ #category : 'accessing' }
ShinGrammarReducerPropertyTest >> shrinkerClass: aClass [

	shrinkerClass := aClass
]

{ #category : 'tests' }
ShinGrammarReducerPropertyTest >> testAlreadyMinimalInputIsUnchanged [

	self assert: ((self newShrinker: [ :s | s includes: $3 ]) shrink: '3') equals: '3'
]

{ #category : 'tests' }
ShinGrammarReducerPropertyTest >> testInputOutsideTheGrammarIsReturnedUnchanged [

	self assert: ((self newShrinker: [ :s | s includes: $3 ]) shrink: '3+') equals: '3+'
]

{ #category : 'tests' }
ShinGrammarReducerPropertyTest >> testInstanceCanBeReused [

	| shrinker first second |
	shrinker := self newShrinker: [ :s | (s includes: $3) and: [ s includes: $7 ] ].

	first := shrinker shrink: '1+(2*3)+4*(5+(6*7))+8'.
	second := shrinker shrink: '1+(2*3)+4*(5+(6*7))+8'.

	self assert: second equals: first
]

{ #category : 'helpers' }
ShinGrammarReducerPropertyTest >> casesNeedingSubtreeHoisting [

	"Reaching a smaller input here requires replacing a node by one of its own subtrees"
	^ #( '1+3' '1+(2*3)' )
]

{ #category : 'helpers' }
ShinGrammarReducerPropertyTest >> reducersWithoutSubtreeHoisting [

	"LazyPerf only replaces subtrees by the minimal derivation of their symbol, by design"
	^ { ShinLazyPerfShrinker }
]

{ #category : 'tests' }
ShinGrammarReducerPropertyTest >> testReducesEveryCase [

	| cases |
	cases := (self reducersWithoutSubtreeHoisting includes: shrinkerClass)
		ifTrue: [ self cases reject: [ :case | self casesNeedingSubtreeHoisting includes: case key ] ]
		ifFalse: [ self cases ].

	"No case is already minimal, so each reducer must make some progress on all of them"
	cases do: [ :case | | result |
		result := (self newShrinker: case value) shrink: case key.
		self
			assert: result size < case key size
			description: [ shrinkerClass name , ' did not reduce ' , case key ] ]
]

{ #category : 'tests' }
ShinGrammarReducerPropertyTest >> testReportsEveryOracleCall [

	| shrinker result |
	shrinker := shrinkerClass new
		            grammar: grammar;
		            oracle: (self countingOracle: [ :s | (s includes: $3) and: [ s includes: $7 ] ]);
		            yourself.

	result := shrinker profiledShrink: '1+(2*3)+4*(5+(6*7))+8'.

	"profiledShrink: evaluates the original and the minimized input once more"
	self assert: (result at: 'neededReductions') equals: calls - 2.
	self assert: (result at: 'failedReductions') <= (result at: 'neededReductions')
]

{ #category : 'tests' }
ShinGrammarReducerPropertyTest >> testResultIsValidAndStillTriggersTheBug [

	self cases do: [ :case | | result |
		result := (self newShrinker: case value) shrink: case key.
		self assert: (case value value: result) description: [ shrinkerClass name , ' lost the behavior on ' , case key ].
		self
			assert: (GncGenericGrammarParser accept: result from: grammar)
			description: [ shrinkerClass name , ' produced ' , result printString , ' outside the grammar' ].
		self assert: result size <= case key size ]
]

{ #category : 'tests' }
ShinGrammarReducerPropertyTest >> testTreeSizeCacheMatchesTheTree [

	| shrinker tree |
	shrinker := self newShrinker: [ :s | (s includes: $3) and: [ s includes: $7 ] ].

	tree := shrinker minimizeOne: (self parse: '1+(2*3)+4*(5+(6*7))+8') upperBound: true.

	self assert: tree treeSize equals: tree allNodes size
]
