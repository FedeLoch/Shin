Class {
	#name : 'ShinReductionShrinkerTest',
	#superclass : 'TestCase',
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'as yet unclassified' }
ShinReductionShrinkerTest >> oracleByBlock: block [

	^ ShinBooleanInputOracle from: block
]
