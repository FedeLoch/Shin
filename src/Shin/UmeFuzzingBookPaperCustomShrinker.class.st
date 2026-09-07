Class {
	#name : 'UmeFuzzingBookPaperCustomShrinker',
	#superclass : 'UmeDDminFuzzingBookShrinker',
	#instVars : [
		'caller'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'accessing' }
UmeFuzzingBookPaperCustomShrinker >> caller: aCaller [

	caller := aCaller.
]

{ #category : 'shrinking' }
UmeFuzzingBookPaperCustomShrinker >> failedMinimization [

	super failedMinimization.
	caller failedMinimization
]

{ #category : 'shrinking' }
UmeFuzzingBookPaperCustomShrinker >> minimizationDone [

	super minimizationDone.
	caller minimizationDone
]
