Class {
	#name : 'ShinProbDDShrinker',
	#superclass : 'ShinShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinProbDDShrinker >> asInput: array [

	^ array
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> minimizeOne: list upperBound: bound [

	^ self minimizeProbDD: list probabilities: (self probabilities: list) upperBound: bound
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> minimizeProbDD: list probabilities: probs upperBound: bound [

	| lmin |
	
	lmin := list.
	
	[ lmin anySatisfy: [ :l | (probs at: l) < 1 ] ] whileTrue: [ | subset complement |
		subset := self selectSubset: lmin probabilities: probs upperBound: bound.
		complement := lmin \ subset.
		self minimizationDone.
		(self triggerBug: complement upperBound: bound) ifTrue: [
			lmin := complement.
		] ifFalse: [ | factor | 
			self failedMinimization.
			factor := 1 / (1 - ((subset collect: [ :elem | 1 - (probs at: elem) ]) multiply)).
			subset do: [ :elem |
				probs at: elem update: [ :p | factor * p ]
			]
		].
	].
	
	^ lmin
]

{ #category : 'instance creation' }
ShinProbDDShrinker >> probabilities: list [

	| p |
	
	p := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :_ |
		dict at: _ put: p.
		dict
	]
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> selectSubset: lmin probabilities: probs upperBound: bound [

	| sorted subset currentMaxGain |
	
	sorted := lmin copy sorted: [ :a :b | (probs at: a) >= (probs at: b) ].
	
	(sorted size = 2) ifTrue: [ ^ { sorted second } ].
	
	subset := {}.
	currentMaxGain := 0.

	sorted do: [ :l | | tempSubset gain |
		tempSubset := subset, { l }.
		gain := tempSubset size * ((tempSubset collect: [ :subL | (1 - (probs at: subL) ) ]) multiply).
		
		(gain > currentMaxGain) ifTrue: [
			currentMaxGain := gain.
			subset := tempSubset.
		] ifFalse: [ ^ subset ]
	].
	
	^ subset
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> sizeOf: string [

	^ string size
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> tree: aString [

	^ aString
]

{ #category : 'testing' }
ShinProbDDShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]
