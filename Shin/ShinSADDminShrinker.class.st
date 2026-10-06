Class {
	#name : 'ShinSADDminShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'pu',
		'pb',
		'c'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSADDminShrinker >> backgroundPerplexity: node [

	"TODO"
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> decisionUniformity: node [

	"TODO"
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> ensureOneMinimal: lmin upperBound: bound [

	lmin do: [ :element | | complement |
		complement := lmin \ { element }.

		(self triggerBug: complement upperBound: bound) ifTrue: [
			^ self ensureOneMinimal: complement upperBound: bound
		]
	].

	^ lmin
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> geometricVolume: node [

	^ node depth * node leaves size
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> initialize [ 
	
	super initialize.
	pu := 1.
	pb := 1.
	c := 16.
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> minimizeOne: tree upperBound: bound [

	| list |
	
	list := tree allNodes.

	^ self minimizeSADDmin: list weights: (self structuralWeightOf: list) upperBound: bound
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> minimizeSADDmin: list weights: weights upperBound: bound [

	| lmin totalWeight |
	
	totalWeight := weights values sum.
	
	lmin := self saddmin: list totalWeight: totalWeight upperBound: bound.
	
	lmin := self ensureOneMinimal: lmin upperBound: bound.
	
	^ list class withAll: lmin
]

{ #category : 'as yet unclassified' }
ShinSADDminShrinker >> saddmin: list totalWeight: totalWeight upperBound: bound [

	"TODO"
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> saturationFunction: x [

	^ x / (x + c)


]

{ #category : 'shrinking' }
ShinSADDminShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> structuralWeightOf: node [

	| geometric decision background |

	geometric := self geometricVolume: node.
	decision := self decisionUniformity: node.
	background := self backgroundPerplexity: node.

	^ geometric * (1 + (pu * decision) + (pb * self saturationFunction: background)) + 1
]
