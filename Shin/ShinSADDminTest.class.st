Class {
	#name : 'ShinSADDminTest',
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
ShinSADDminTest >> setUp [

	super setUp.
	super timeLimit: 5 minutes.
	shrinker := ShinSADDminShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).

	self assert: (shrinker shrink: '1+3') equals: '3'
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer02 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '(2)'
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer03 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).

	self assert: (shrinker shrink: '1+(3)') equals: '(3)'
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer04 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '1+(3)'
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '(3)'
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [ (string includes: $3) ] ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '(23)'
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [ (string includes: $1) ] ]).

	self assert: (shrinker shrink: '1+(2*3)') equals: '1+(2)'
]

{ #category : 'tests' }
ShinSADDminTest >> testSADDminReducer08 [

	| res |

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).
	shrinker grammar: SvgPathGrammar new.
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.

	self assert: res equals: 'm2-5'
]
