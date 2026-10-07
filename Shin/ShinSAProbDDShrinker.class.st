Class {
	#name : 'ShinSAProbDDShrinker',
	#superclass : 'ShinSADDShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSAProbDDShrinker >> minimizeSAProbDD: list probabilities: probs weights: someWeights upperBound: bound [

	| lmin |

	weights := someWeights.
	lmin := list.

	[ lmin anySatisfy: [ :element | (probs at: element) < 1 ] ] whileTrue: [ | subset complement |
		subset := self selectSubset: lmin probabilities: probs.
		complement := lmin \ subset.
		self minimizationDone.
		(self triggerBug: complement upperBound: bound)
			ifTrue: [ lmin := complement ]
			ifFalse: [ | factor |
				self failedMinimization.
				factor := 1 / (1 - (subset collect: [ :elem | 1 - (probs at: elem) ]) multiply).
				subset do: [ :elem | probs at: elem update: [ :p | factor * p ]
			]
		]
	].

	^ list class withAll: lmin
]

{ #category : 'shrinking' }
ShinSAProbDDShrinker >> reduceCandidates: list upperBound: bound [

	^ self minimizeSAProbDD: list probabilities: (self probabilities: list) weights: weights upperBound: bound
]

{ #category : 'shrinking' }
ShinSAProbDDShrinker >> selectSubset: lmin probabilities: probs [

	| sorted result prefix currentMaxGain |

	sorted := lmin copy sorted: [ :a :b |
		(self ddvalue: a probabilities: probs) >= (self ddvalue: b probabilities: probs)
	].

	result := {}.
	prefix := {}.
	currentMaxGain := 0.

	sorted do: [ :element | | weight probOfDeletion gain |
		prefix := prefix, { element }.
		weight := (prefix collect: [ :subElement | weights at: subElement ]) sum.
		probOfDeletion := (prefix collect: [ :subElement | 1 - (probs at: subElement) ]) multiply.
		gain := weight * probOfDeletion.

		(gain > currentMaxGain) ifTrue: [
			currentMaxGain := gain. result := prefix ] ifFalse: [
			^ result
		]
	].

	^ result
]
