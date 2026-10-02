Class {
	#name : 'ShinWDDProbShrinker',
	#superclass : 'ShinShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinWDDProbShrinker >> asInput: array [

	^ array
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> ddvalue: element probabilities: probs weights: weights [

	^ (weights at: element) * (1 - (probs at: element))
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> minimizeOne: list upperBound: bound [

	^ self minimizeWDDProb: list probabilities: (self probabilities: list) weights: (self weights: list) upperBound: bound
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> minimizeWDDProb: list probabilities: probs weights: weights upperBound: bound [

	| lmin |
	
	lmin := list.
	
	[ lmin anySatisfy: [ :l | (probs at: l) < 1 ] ] whileTrue: [ | subset complement |
		subset := self selectSubsetWDD: lmin probabilities: probs weights: weights upperBound: bound.
		complement := lmin \ subset.

		(self triggerBug: complement upperBound: bound) ifTrue: [
			lmin := complement.
		] ifFalse: [ | factor | 
			factor := 1 / (1 - ((subset collect: [ :elem | 1 - (probs at: elem) ]) multiply)).
			subset do: [ :elem |
				probs at: elem update: [ :p | factor * p ]
			]
		].
	].
	
	^ lmin
]

{ #category : 'instance creation' }
ShinWDDProbShrinker >> probabilities: list [

	| p |
	
	p := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :_ |
		dict at: _ put: p.
		dict
	]
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> selectSubsetWDD: lmin probabilities: probs weights: weights upperBound: bound [

	| sorted result ptn currentMaxGain |
	
	sorted := lmin copy sorted: [ :a :b |
		(self ddvalue: a probabilities: probs weights: weights) >= (self ddvalue: b probabilities: probs weights: weights)
	].
	
	result := {}.
	ptn := {}.
	currentMaxGain := 0.

	sorted do: [ :element | | weight probOfDeletion gain |
		ptn := ptn, { element }.
		weight := (ptn collect: [ :subL | weights at: subL ]) sum.
		probOfDeletion := ((ptn collect: [ :subL | (1 - (probs at: subL) ) ]) multiply).
		gain := weight * probOfDeletion.
		
		(gain > currentMaxGain) ifTrue: [
			currentMaxGain := gain.
			result := ptn.
		] ifFalse: [ ^ result ]
	].
	
	^ result
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> sizeOf: string [

	^ string size
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> tree: aString [

	^ aString
]

{ #category : 'testing' }
ShinWDDProbShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> weights: list [

	| weight |
	
	weight := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :_ |
		dict at: _ put: weight.
		dict
	]
]
