Class {
	#name : 'ShinSADDminShrinker',
	#superclass : 'ShinSADDShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSADDminShrinker >> minimizeSADDmin: list weights: aWeights upperBound: bound [

	| lmin totalWeight |

	weights := aWeights.
	totalWeight := weights values sum.
	seen := Set new.

	lmin := self saddmin: list totalWeight: totalWeight upperBound: bound.
	lmin := self ensureOneMinimal: lmin upperBound: bound.

	^ list class withAll: lmin
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> reduceCandidates: list upperBound: bound [

	^ self minimizeSADDmin: list weights: weights upperBound: bound
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> saddmin2: cFail totalWeight: totalWeight upperBound: bound granularity: n [

	| key partitions |

	key := { cFail . n }.
	(seen includes: key) ifTrue: [ ^ cFail ].

	seen add: key.

	partitions := self weightBalancedPartitions: cFail totalWeight: totalWeight count: n.

	1 to: partitions size do: [ :i | | subset |
		subset := partitions at: i.
		self minimizationDone.
		(self triggerBug: subset upperBound: bound)
			ifTrue: [ ^ self saddmin2: subset totalWeight: (self totalWeightOf: subset) upperBound: bound granularity: 2 ]
			ifFalse: [ self failedMinimization ]
	].

	1 to: partitions size do: [ :i | | subset complement |
		subset := partitions at: i.
		complement := cFail \ subset.
		self minimizationDone.
		(self triggerBug: complement upperBound: bound)
			ifTrue: [ ^ self saddmin2: complement totalWeight: (self totalWeightOf: complement) upperBound: bound granularity: ((n - 1) max: 2) ]
			ifFalse: [ self failedMinimization ]
	].

	n < cFail size ifTrue: [
		^ self saddmin2: cFail totalWeight: totalWeight upperBound: bound granularity: ((2 * n) min: cFail size)
	].

	^ cFail
]

{ #category : 'shrinking' }
ShinSADDminShrinker >> saddmin: list totalWeight: totalWeight upperBound: bound [

	^ self saddmin2: list totalWeight: totalWeight upperBound: bound granularity: 2
]
