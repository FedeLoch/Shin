Class {
	#name : 'ShinStrategyShrinkerTest',
	#superclass : 'ShinReductionShrinkerTest',
	#instVars : [
		'shrinker',
		'grammar'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'accessing' }
ShinStrategyShrinkerTest >> setUp [

	super setUp.
	shrinker := ShinGRABRShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer00 [ 

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(3)' ]).
	shrinker reductionStrategy: ShinSimplifyGrammarAlternateReduction . 
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer02 [
	
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(3)' ]).
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer03 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3*2' ) equals: '3'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3' ) equals: '3'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
	shrinker reductionStrategy: ShinSimplifyGrammarSubtreeReducer . 
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '(3)'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '4' ]).
	shrinker reductionStrategy: ShinSimplifyGrammarSubtreeReducer . 
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '1+(3)'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer08 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '2' ]).
	shrinker reductionStrategy: ShinSimplifyGrammarAlternateReduction . 

	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer09 [

	| res |

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $3) and: (string includes: $1) ]).
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	res:= shrinker shrink: '3*2+(4*1)'.
	
	self assert:  ((res = '3*1') or: (res = '3+1'))
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer10 [

	| grammar2 oracle input |
	grammar2 := GncRegexGrammar new.
	oracle := ShinExecutionTimeOracle new threshold: 0.9; evalBlock: [ :regex |
		regex asRegex matches: regex minimalStringMatching
	].

	shrinker oracle: oracle.
	shrinker grammar: grammar2.
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	input := 'b.*(acca+a*..(.)c|.*|||)(b+|b?|cb*b*)c+'.
	
	self assert:  (shrinker shrink: input) size < input size 
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer11 [

	| oracle input |
	oracle := ShinExecutionTimeOracle new threshold: 0.9; evalBlock: [ :path | SVGRunner run: path ].

	shrinker oracle: oracle.
	shrinker grammar: SvgPathGrammar new.
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	input := 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  (shrinker shrink: input) size < (input size)
]

{ #category : 'tests' }
ShinStrategyShrinkerTest >> testGrammarReducer12 [

	| oracle res |
	oracle := (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).

	shrinker oracle: oracle.
	shrinker grammar: SvgPathGrammar new.
	shrinker reductionStrategy: ShinSimplifyGrammarBoth.
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  res equals: 'm2-5'
]
