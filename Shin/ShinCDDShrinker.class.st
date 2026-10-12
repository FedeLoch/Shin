Class {
	#name : 'ShinCDDShrinker',
	#superclass : 'ShinShrinker',
	#instVars : [
		'source'
	],
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
ShinCDDShrinker >> minimizeCDD: list upperBound: bound [

	"list holds positions of the input, so repeated elements are removed independently"

	| round lmin p size |

	lmin := list.
	round := 0.
	p := (1 / list size) asFloat.
	size := nil.

	[size isNil or: [ size > 1 ]] whileTrue: [ | subsets |
		size := self computeSize: round probability: p.
		subsets := self partitions: lmin size: size.
		subsets do: [ :subset | | toRemove complement |
			toRemove := subset asSet.
			complement := lmin reject: [ :index | toRemove includes: index ].
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

	list size <= 1 ifTrue: [ ^ list ].

	source := list.
	^ self elementsOf: source at: (self minimizeCDD: (1 to: list size) asArray upperBound: bound)
]

{ #category : 'shrinking' }
ShinCDDShrinker >> partitions: lmin size: size [

	| subsets |

	subsets := OrderedCollection new.
	1 to: lmin size by: size do: [ :start |
		subsets add: (lmin copyFrom: start to: (start + size - 1 min: lmin size)) ].

	^ subsets
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
ShinCDDShrinker >> triggerBug: indices upperBound: originalScore [

	^ oracle accepts: (self asInput: (self elementsOf: source at: indices)) from: originalScore
]
