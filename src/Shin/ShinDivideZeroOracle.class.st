Class {
	#name : 'ShinDivideZeroOracle',
	#superclass : 'ShinInputOracle',
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinDivideZeroOracle >> accepts: input from: _ [ 

	[
		OpalCompiler new
			source: input;
			evaluate ]
		on: Error
		do: [ :error | ^ error isKindOf: ZeroDivide ].

	^ false
]

{ #category : 'as yet unclassified' }
ShinDivideZeroOracle >> evalInput: input [

	^ self accepts: input from: nil
]

{ #category : 'as yet unclassified' }
ShinDivideZeroOracle >> valueBound: bound [

	^ bound ifTrue: [ 100 ] ifFalse: [ 0 ]
]
