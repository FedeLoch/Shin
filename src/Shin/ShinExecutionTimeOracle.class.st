Class {
	#name : 'ShinExecutionTimeOracle',
	#superclass : 'ShinThresholdOracle',
	#instVars : [
		'evalBlock'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinExecutionTimeOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'as yet unclassified' }
ShinExecutionTimeOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
ShinExecutionTimeOracle >> evalInput: input [

	^ (1 timesCollect: [
		[ evalBlock value: input ] microsecondsToRun
	]) average
]
