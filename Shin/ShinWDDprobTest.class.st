Class {
	#name : 'ShinWDDprobTest',
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
ShinWDDprobTest >> setUp [

	super setUp.
	shrinker := ShinWDDProbShrinker new.	
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $e) ]).

]

{ #category : 'running' }
ShinWDDprobTest >> testString [ 
	
	self assert: (shrinker shrink: 'asqjjkqsbdvieqvsbdoivbq') equals: 'e'
]

{ #category : 'running' }
ShinWDDprobTest >> testString02 [

	self assert: (shrinker shrink: 'e') equals: 'e'
]

{ #category : 'running' }
ShinWDDprobTest >> testString03 [

	self assert: (shrinker shrink: 'eq') equals: 'e'
]

{ #category : 'running' }
ShinWDDprobTest >> testString04 [
	
	self assert: (shrinker shrink: 'e') equals: 'e'
]

{ #category : 'running' }
ShinWDDprobTest >> testString05 [

	shrinker oracle: (self oracleByBlock: [ :string |
			 (string includes: $e) and: (string includes: $a) ]).

	self
		assert: (shrinker shrink: 'kjdsfhkjqsdhfehdkjsqfhkjsa')
		equals: 'ea'
]

{ #category : 'running' }
ShinWDDprobTest >> testString06 [
	
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]
