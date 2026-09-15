Class {
	#name : 'ShinDDFuzzingBookTest',
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
ShinDDFuzzingBookTest >> setUp [

	super setUp.
	shrinker := ShinDDminFuzzingBookShrinker new.	
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $e) ]).

]

{ #category : 'running' }
ShinDDFuzzingBookTest >> testString [ 
	
	self assert: (shrinker shrink: 'asqjjkqsbdvieqvsbdoivbq') equals: 'e'
]

{ #category : 'running' }
ShinDDFuzzingBookTest >> testString02 [

	self assert: (shrinker shrink: 'e') equals: 'e'
]

{ #category : 'running' }
ShinDDFuzzingBookTest >> testString03 [

	self assert: (shrinker shrink: 'eq') equals: 'e'
]

{ #category : 'running' }
ShinDDFuzzingBookTest >> testString04 [
	
	self assert: (shrinker shrink: 'eeeeeeeeeeeeeeeeeeeeeeeeee') equals: 'e'
]

{ #category : 'running' }
ShinDDFuzzingBookTest >> testString05 [

	shrinker oracle: (self oracleByBlock: [ :string |
			 (string includes: $e) and: (string includes: $a) ]).

	self
		assert: (shrinker shrink: 'kjdsfhkjqsdhfehdkjsqfhkjsa')
		equals: 'ea'
]

{ #category : 'running' }
ShinDDFuzzingBookTest >> testString06 [
	
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]
