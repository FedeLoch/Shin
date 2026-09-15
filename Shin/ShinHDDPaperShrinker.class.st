Class {
	#name : 'ShinHDDPaperShrinker',
	#superclass : 'ShinHDDShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinHDDPaperShrinker >> initialize [ 

	super initialize.
	seen := Set new.
	"ddmin := ShinDDminPaperCustomShrinker new caller: self."
	ddmin := ShinDDminPaperCustomShrinker new caller: self.
	
]
