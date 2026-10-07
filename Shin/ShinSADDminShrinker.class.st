Class {
	#name : 'ShinSADDminShrinker',
	#superclass : 'ShinSADDShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSADDminShrinker >> reduceCandidates: list upperBound: bound [

	^ self minimizeSADDmin: list weights: weights upperBound: bound
]