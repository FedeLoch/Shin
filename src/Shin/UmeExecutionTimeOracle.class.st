Class {
	#name : 'UmeExecutionTimeOracle',
	#superclass : 'UmeThresholdOracle',
	#instVars : [
		'evalBlock'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalInput: input [

	^ (1 timesCollect: [
		[ evalBlock value: input ] microsecondsToRun
	]) average
]
