Class {
	#name : 'ShinCoverageOracle',
	#superclass : 'ShinThresholdOracle',
	#instVars : [
		'evalBlock',
		'methodsToInstrument',
		'collector'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinCoverageOracle >> accepts: input from: baseline [

	| current |
	
	current := [ self evalInput: input ] on: Error do: [ ^ false ].

	^ current = baseline
]

{ #category : 'accessing' }
ShinCoverageOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'accessing' }
ShinCoverageOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
ShinCoverageOracle >> evalInput: input [

	| result |
	
	
	result := collector runOn: [ evalBlock value: input ].

	^ result nodes collect: #asString as: Set.
]

{ #category : 'initialization' }
ShinCoverageOracle >> initialize [ 

	super initialize.
	collector := C2CoverageCollector new methods: {}.
	threshold := 1.
]

{ #category : 'accessing' }
ShinCoverageOracle >> methodsToInstrument [ 

	^ methodsToInstrument 
]

{ #category : 'accessing' }
ShinCoverageOracle >> methodsToInstrument: methods [

	methodsToInstrument := methods.
	collector methods: methodsToInstrument.
	
]

{ #category : 'shrinking' }
ShinCoverageOracle >> percentageProblemPreservation: upperBound given: currentBound [

	^ 100
]
