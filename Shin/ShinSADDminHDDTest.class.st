Class {
	#name : 'ShinSADDminHDDTest',
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
ShinSADDminHDDTest >> setUp [

	super setUp.
	super timeLimit: 5 minutes.
	shrinker := ShinSADDminHDDShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).

	self assert: (shrinker shrink: '1+3') equals: '3'
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer02 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '2'
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer03 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).

	self assert: (shrinker shrink: '1+(3)') equals: '(3)'
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer04 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '1+(2)'
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '3'
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [ (string includes: $3) ] ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '23'
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [ (string includes: $1) ] ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '1+(2)'
]

{ #category : 'tests' }
ShinSADDminHDDTest >> testSADDminHDDReducer08 [

	| res |

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).
	shrinker grammar: SvgPathGrammar new.
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.

	self assert: res equals: 'm2-5'
]
