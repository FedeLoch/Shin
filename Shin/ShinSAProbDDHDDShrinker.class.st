Class {
	#name : 'ShinSAProbDDHDDShrinker',
	#superclass : 'ShinHDDShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSAProbDDHDDShrinker >> initialize [

	super initialize.
	ddmin := ShinSAProbDDShrinker new caller: self
]