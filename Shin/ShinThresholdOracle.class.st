Class {
	#name : 'ShinThresholdOracle',
	#superclass : 'ShinInputOracle',
	#instVars : [
		'threshold'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinThresholdOracle >> accepts: input from: baseline [

	^ [ (self evalInput: input) >= (baseline * threshold) ] on: Error do: [ :e | ^ false ]
]

{ #category : 'as yet unclassified' }
ShinThresholdOracle >> evalInput: input [

	self subclassResponsibility 
]

{ #category : 'initialization' }
ShinThresholdOracle >> initialize [ 

	threshold := 0.95
]

{ #category : 'initialization' }
ShinThresholdOracle >> threshold [

	^ threshold
]

{ #category : 'initialization' }
ShinThresholdOracle >> threshold: aThreshold [

	threshold := aThreshold 
]

{ #category : 'initialization' }
ShinThresholdOracle >> valueBound: bound [

	^ bound
]
