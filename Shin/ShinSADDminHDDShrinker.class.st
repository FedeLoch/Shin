Class {
	#name : 'ShinSADDminHDDShrinker',
	#superclass : 'ShinHDDShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSADDminHDDShrinker >> initialize [

	super initialize.
	ddmin := ShinSADDminShrinker new caller: self
]
