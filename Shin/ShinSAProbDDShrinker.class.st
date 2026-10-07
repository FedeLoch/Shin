Class {
	#name : 'ShinSAProbDDShrinker',
	#superclass : 'ShinSADDShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSAProbDDShrinker >> reduceCandidates: list upperBound: bound [

	^ self minimizeSAProbDD: list probabilities: (self probabilities: list) weights: weights upperBound: bound
]
