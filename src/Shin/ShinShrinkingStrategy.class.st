Class {
	#name : 'ShinShrinkingStrategy',
	#superclass : 'Object',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'copying' }
ShinShrinkingStrategy class >> copyTree: aTree [

	^ aTree doCopy. 
]

{ #category : 'enumerating' }
ShinShrinkingStrategy class >> reduce: subtree using: grammar matching: symbol [

	self subclassResponsibility 
]
