Class {
	#name : 'ShinWDDProbShrinker',
	#superclass : 'ShinShrinker',
	#instVars : [
		'source'
	],
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

	| indices |

	list size <= 1 ifTrue: [ ^ list ].

	source := list.
	indices := (1 to: list size) asArray.

	^ self elementsOf: source at: (self minimizeWDDProb: indices probabilities: (self probabilities: indices) weights: (self weights: indices) upperBound: bound)
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> minimizeWDDProb: list probabilities: probs weights: weights upperBound: bound [

	| lmin |
	
	lmin := list.
	
	[ lmin anySatisfy: [ :l | (probs at: l) < 1 ] ] whileTrue: [ | subset complement |
		subset := self selectSubsetWDD: lmin probabilities: probs weights: weights upperBound: bound.
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
ShinWDDProbShrinker >> probabilities: list [

	| p |
	
	p := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :element |
		dict at: element put: p.
		dict
	]
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> selectSubsetWDD: lmin probabilities: probs weights: weights upperBound: bound [

	| sorted result ptn currentMaxGain |
	
	sorted := lmin asArray sorted: [ :a :b |
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
ShinWDDProbShrinker >> triggerBug: indices upperBound: originalScore [

	^ oracle accepts: (self asInput: (self elementsOf: source at: indices)) from: originalScore
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> update: probs afterFailing: subset [

	"Bayesian update after the subset could not be removed. A failed singleton is
	certainly needed, so its probability is set to exactly 1 (no floating point drift)."

	| factor |

	subset size = 1 ifTrue: [ ^ probs at: subset first put: 1 ].

	factor := 1 / (1 - ((subset collect: [ :elem | 1 - (probs at: elem) ]) multiply)).
	subset do: [ :elem |
		probs at: elem update: [ :p | (factor * p) min: 1 ]
	]
]

{ #category : 'shrinking' }
ShinWDDProbShrinker >> weights: list [

	| weight |
	
	weight := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :element |
		dict at: element put: weight.
		dict
	]
]
