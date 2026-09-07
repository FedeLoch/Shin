Class {
	#name : 'ShinBooleanInputOracle',
	#superclass : 'ShinInputOracle',
	#instVars : [
		'block'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'instance creation' }
ShinBooleanInputOracle class >> from: booleanBlock [

	^ self new block: booleanBlock

	
	
]

{ #category : 'as yet unclassified' }
ShinBooleanInputOracle >> accepts: input from: _ [
	
	^ block value: input
]

{ #category : 'accessing' }
ShinBooleanInputOracle >> block: booleanBlock [

	block := booleanBlock
]

{ #category : 'as yet unclassified' }
ShinBooleanInputOracle >> evalInput: aBlock [ 

	^ self accepts: aBlock from: nil  
]

{ #category : 'as yet unclassified' }
ShinBooleanInputOracle >> valueBound: bound [

	^ bound ifTrue: [ 100 ] ifFalse: [ 0 ]

]
