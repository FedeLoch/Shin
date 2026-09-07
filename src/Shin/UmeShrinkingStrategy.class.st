Class {
	#name : 'UmeShrinkingStrategy',
	#superclass : 'Object',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'copying' }
UmeShrinkingStrategy class >> copyTree: aTree [

	^ aTree doCopy. 
]

{ #category : 'enumerating' }
UmeShrinkingStrategy class >> reduce: subtree using: grammar matching: symbol [

	self subclassResponsibility 
]
