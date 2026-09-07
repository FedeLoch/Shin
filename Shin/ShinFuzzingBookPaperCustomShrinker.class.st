Class {
	#name : 'ShinFuzzingBookPaperCustomShrinker',
	#superclass : 'ShinDDminFuzzingBookShrinker',
	#instVars : [
		'caller'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'accessing' }
ShinFuzzingBookPaperCustomShrinker >> caller: aCaller [

	caller := aCaller.
]

{ #category : 'shrinking' }
ShinFuzzingBookPaperCustomShrinker >> failedMinimization [

	super failedMinimization.
	caller failedMinimization
]

{ #category : 'shrinking' }
ShinFuzzingBookPaperCustomShrinker >> minimizationDone [

	super minimizationDone.
	caller minimizationDone
]
