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
	
	current := [self evalInput: input] on: Error do: [ ^ false ].

	current keys do: [ :key |
		(baseline at: key) ~= (current at: key) ifTrue: [ ^ false ]
	].

	^ true
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
	" return the coverage table "
	result := collector runOn: [ evalBlock value: input ].
	^ {
		  ('percetange' -> result percentage).
		  ('nodes' -> result nodes size).
		  ( 'methods' -> result methods size)
	} asDictionary 
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
