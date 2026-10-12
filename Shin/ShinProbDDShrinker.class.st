Class {
	#name : 'ShinProbDDShrinker',
	#superclass : 'ShinShrinker',
	#instVars : [
		'source'
	],
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

	| indices |

	list size <= 1 ifTrue: [ ^ list ].

	source := list.
	indices := (1 to: list size) asArray.

	^ self elementsOf: source at: (self minimizeProbDD: indices probabilities: (self probabilities: indices) upperBound: bound)
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> minimizeProbDD: list probabilities: probs upperBound: bound [

	"list holds positions of the input, so repeated elements have independent probabilities"

	| lmin |

	lmin := list.

	[ lmin anySatisfy: [ :l | (probs at: l) < 1 ] ] whileTrue: [ | subset complement |
		subset := self selectSubset: lmin probabilities: probs upperBound: bound.
		complement := lmin reject: [ :l | subset includes: l ].
		self minimizationDone.
		(self triggerBug: complement upperBound: bound) ifTrue: [
			lmin := complement.
		] ifFalse: [
			self failedMinimization.
			self update: probs afterFailing: subset
		].
	].

	^ lmin
]

{ #category : 'instance creation' }
ShinProbDDShrinker >> probabilities: list [

	| p |

	p := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :element |
		dict at: element put: p.
		dict
	]
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> selectSubset: lmin probabilities: probs upperBound: bound [

	"Elements least likely to be needed (lowest probability) first: grow the prefix
	while the expected gain |S| * prod(1 - p) keeps increasing."

	| sorted subset currentMaxGain |

	sorted := lmin asArray sorted: [ :a :b | (probs at: a) <= (probs at: b) ].

	subset := #().
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
ShinProbDDShrinker >> triggerBug: indices upperBound: originalScore [

	^ oracle accepts: (self asInput: (self elementsOf: source at: indices)) from: originalScore
]

{ #category : 'shrinking' }
ShinProbDDShrinker >> update: probs afterFailing: subset [

	"Bayesian update after the subset could not be removed. A failed singleton is
	certainly needed, so its probability is set to exactly 1 (no floating point drift)."

	| factor |

	subset size = 1 ifTrue: [ ^ probs at: subset first put: 1 ].

	factor := 1 / (1 - ((subset collect: [ :elem | 1 - (probs at: elem) ]) multiply)).
	subset do: [ :elem |
		probs at: elem update: [ :p | (factor * p) min: 1 ]
	]
]
