Class {
	#name : 'ShinHDDFuzzingBookTest',
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
ShinHDDFuzzingBookTest >> setUp [

	super setUp.
	super timeLimit: 5 minutes. 
	shrinker := ShinHDDShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+3' ) equals: '3'
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer02 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1+(2)'
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer02v2 [

	| input |

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).
	
	input := '(2)'.
	
	self assert:  (shrinker shrink: input ) equals: input
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer03 [

	| input |

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
	
	input := '1+(3)'.
	
	self assert: (shrinker shrink: input ) equals: input
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer04 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1+(2)'
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1+(3)'
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [(string includes: $3)] ]).
	
	self assert:  ( shrinker shrink: '1+(2*3)' ) equals: '1+(23)'
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [(string includes: $1)] ]).
	
	self assert:  ( shrinker shrink: '1+(2*3)' ) equals: '1+(2)'
]

{ #category : 'tests' }
ShinHDDFuzzingBookTest >> testHDDReducer08 [

	| res |
	
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).
	shrinker grammar: SvgPathGrammar new.
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  res equals: 'm2-5'
]
