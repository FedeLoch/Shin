Class {
	#name : 'ShinInputOracle',
	#superclass : 'Object',
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinInputOracle >> accepts: bound from: base [

	"It returns true if the input triggers the bug"
	self subclassResponsibility 
]

{ #category : 'shrinking' }
ShinInputOracle >> evalInput: input [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
ShinInputOracle >> percentageProblemPreservation: upperBound given: currentBound [

	| baseline current |
	
	baseline := self valueBound: upperBound.
	current := self valueBound: currentBound.
	
	(baseline = 0) ifTrue: [ ^ 0 ].
	
	^ ((current * 100) / baseline) asFloat
]

{ #category : 'as yet unclassified' }
ShinInputOracle >> valueBound: bound [

	self subclassResponsibility 
]
