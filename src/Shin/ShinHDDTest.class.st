Class {
	#name : 'ShinHDDTest',
	#superclass : 'ShinReductionShrinkerTest',
	#instVars : [
		'shrinker',
		'grammar'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'running' }
ShinHDDTest >> setUp [

	super setUp.
	super timeLimit: 5 minutes. 
	shrinker := ShinHDDShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+3' ) equals: '3'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer02 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer02v2 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).
	
	self assert:  (shrinker shrink: '(2)' ) equals: '2'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer03 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
	
	self assert: (shrinker shrink: '1+(3)' ) equals: '(3)'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer04 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [(string includes: $3)] ]).
	
	self assert:  ( shrinker shrink: '1+(2*3)' ) equals: '23'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [(string includes: $1)] ]).
	
	self assert:  ( shrinker shrink: '1+(2*3)' ) equals: '1+(2)'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer08 [

	| res |
	
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).
	shrinker grammar: SvgPathGrammar new.
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  res equals: 'm2-5'
]

{ #category : 'tests' }
ShinHDDTest >> testHDDReducer09 [

	| oracle input |
	oracle := ShinExecutionTimeOracle new evalBlock: [ :path | SVGRunner run: path ].
	
	shrinker oracle: oracle.
	shrinker grammar: SvgPathGrammar new.
	
	input := 'm-.99,-.4,7-933.,03-.8 -319.9-.62449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert: (shrinker shrink: input) size < (input size)
]
