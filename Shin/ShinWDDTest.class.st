Class {
	#name : 'ShinWDDTest',
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
ShinWDDTest >> setUp [

	super setUp.
	shrinker := ShinWDDminShrinker new.	
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $e) ]).

]

{ #category : 'running' }
ShinWDDTest >> testString [ 
	
	self assert: (shrinker shrink: 'asqjjkqsbdvieqvsbdoivbq') equals: 'e'
]

{ #category : 'running' }
ShinWDDTest >> testString02 [

	self assert: (shrinker shrink: 'e') equals: 'e'
]

{ #category : 'running' }
ShinWDDTest >> testString03 [

	self assert: (shrinker shrink: 'eq') equals: 'e'
]

{ #category : 'running' }
ShinWDDTest >> testString04 [
	
	self assert: (shrinker shrink: 'eeeeeeeeeeeeeeeeeeeeeeeeee') equals: 'e'
]

{ #category : 'running' }
ShinWDDTest >> testString05 [

	shrinker oracle: (self oracleByBlock: [ :string |
			 (string includes: $e) and: (string includes: $a) ]).

	self
		assert: (shrinker shrink: 'kjdsfhkjqsdhfehdkjsqfhkjsa')
		equals: 'ea'
]

{ #category : 'running' }
ShinWDDTest >> testString06 [
	
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]
