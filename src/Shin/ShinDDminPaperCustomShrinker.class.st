Class {
	#name : 'ShinDDminPaperCustomShrinker',
	#superclass : 'ShinDDminPaperShrinker',
	#instVars : [
		'caller'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'accessing' }
ShinDDminPaperCustomShrinker >> caller: aCaller [

	caller := aCaller.
]

{ #category : 'shrinking' }
ShinDDminPaperCustomShrinker >> failedMinimization [

	super failedMinimization.
	caller failedMinimization
]

{ #category : 'shrinking' }
ShinDDminPaperCustomShrinker >> minimizationDone [

	super minimizationDone.
	caller minimizationDone
]
