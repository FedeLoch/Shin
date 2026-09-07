Class {
	#name : 'ShinShrinkerTest',
	#superclass : 'Object',
	#instVars : [
		'input',
		'oracle'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'as yet unclassified' }
ShinShrinkerTest class >> input: input oracle: oracle [

	^ self new input: input; oracle: oracle
]

{ #category : 'accessing' }
ShinShrinkerTest >> input [

	^ input
]

{ #category : 'accessing' }
ShinShrinkerTest >> input: anInput [

	input := anInput 
]

{ #category : 'accessing' }
ShinShrinkerTest >> oracle [

	^ oracle
]

{ #category : 'accessing' }
ShinShrinkerTest >> oracle: anOracle [

	oracle := anOracle 
]
