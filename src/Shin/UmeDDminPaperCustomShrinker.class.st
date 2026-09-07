Class {
	#name : 'UmeDDminPaperCustomShrinker',
	#superclass : 'UmeDDminPaperShrinker',
	#instVars : [
		'caller'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'accessing' }
UmeDDminPaperCustomShrinker >> caller: aCaller [

	caller := aCaller.
]

{ #category : 'shrinking' }
UmeDDminPaperCustomShrinker >> failedMinimization [

	super failedMinimization.
	caller failedMinimization
]

{ #category : 'shrinking' }
UmeDDminPaperCustomShrinker >> minimizationDone [

	super minimizationDone.
	caller minimizationDone
]
