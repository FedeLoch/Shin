Class {
	#name : 'ShinMethodCallsOracle',
	#superclass : 'ShinThresholdOracle',
	#instVars : [
		'evalBlock',
		'methodsToInstrument',
		'analyzer'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinMethodCallsOracle >> caseFor: input [

	| case |
	
	case := PBAProgram
		        from: [ evalBlock value: input ]
		        forClasses: {  }.

	case methodsToInstrument: methodsToInstrument.
	
	^ case
]

{ #category : 'accessing' }
ShinMethodCallsOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'accessing' }
ShinMethodCallsOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
ShinMethodCallsOracle >> evalInput: input [
	
	" return the number of methods called "
	^ (analyzer analyze: (self caseFor: input)) methodsCalled values sum
]

{ #category : 'initialization' }
ShinMethodCallsOracle >> initialize [ 

	super initialize.
	analyzer := PBAnalyzer new profilers: { PBAMethodProfiler new }
]

{ #category : 'accessing' }
ShinMethodCallsOracle >> methodsToInstrument [ 

	^ methodsToInstrument 
]

{ #category : 'accessing' }
ShinMethodCallsOracle >> methodsToInstrument: methods [

	methodsToInstrument := methods 
]
