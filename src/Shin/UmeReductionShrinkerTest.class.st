Class {
	#name : 'UmeReductionShrinkerTest',
	#superclass : 'TestCase',
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'as yet unclassified' }
UmeReductionShrinkerTest >> oracleByBlock: block [

	^ UmeBooleanInputOracle from: block
]
