Class {
	#name : 'ShinCDDShrinker',
	#superclass : 'ShinShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinCDDShrinker >> asInput: array [

	^ array
]

{ #category : 'shrinking' }
ShinCDDShrinker >> computeSize: round probability: prob [

	| estimatedProb q real lower upper |
	
	"Estimated probability of round r"
	estimatedProb := prob * (1.582 ** round).
	estimatedProb >= 1 ifTrue: [ ^ 1 ].

	"Corresponding subset size: argmax over s in N+ of s * (1 - pr)^s"
	q := 1 - estimatedProb.
	real := -1 / q ln. "continuous maximiser: s = -1 / ln(1 - pr)"
	lower := real floor max: 1.
	upper := real ceiling max: 1.

	"f(s) = s * q^s is unimodal, so the integer argmax is floor or ceiling"
	^ (lower * (q raisedTo: lower)) >= (upper * (q raisedTo: upper))
		ifTrue: [ lower ]
		ifFalse: [ upper ]
]

{ #category : 'shrinking' }
ShinCDDShrinker >> minimizeCDD: list probabilities: probs upperBound: bound [

	| round lmin p size |
	
	lmin := list.
	round := 0.
	p := (1 / list size) asFloat.
	size := nil.
	
	[size isNil or: [ size > 1 ]] whileTrue: [ | subsets |
		size := self computeSize: round probability: p.	
		subsets := self partitions: lmin size: size.
		subsets do: [ :subset | | complement |
			complement := lmin \ subset.
			self minimizationDone.
			(self triggerBug: complement upperBound: bound) ifTrue: [
				lmin := complement.
			] ifFalse: [
				self failedMinimization.
			]
		].
		round := round + 1.
	].

	^ lmin
]

{ #category : 'shrinking' }
ShinCDDShrinker >> minimizeOne: list upperBound: bound [

	^ self minimizeCDD: list probabilities: (self probabilities: list) upperBound: bound
]

{ #category : 'shrinking' }
ShinCDDShrinker >> partitions: lmin size: size [

	| subsets |

	subsets := OrderedCollection new.
	1 to: lmin size by: size do: [ :start |
		subsets add: (lmin copyFrom: start to: (start + size - 1 min: lmin size)) ].

	^ subsets
]

{ #category : 'instance creation' }
ShinCDDShrinker >> probabilities: list [

	| p |
	
	p := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :_ |
		dict at: _ put: p.
		dict
	]
]

{ #category : 'shrinking' }
ShinCDDShrinker >> selectSubset: lmin probabilities: probs upperBound: bound [

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
ShinCDDShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
ShinCDDShrinker >> sizeOf: string [

	^ string size
]

{ #category : 'shrinking' }
ShinCDDShrinker >> tree: aString [

	^ aString
]

{ #category : 'testing' }
ShinCDDShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]
