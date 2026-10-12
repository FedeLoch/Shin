Class {
	#name : 'ShinWDDminShrinker',
	#superclass : 'ShinShrinker',
	#instVars : [
		'source'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinWDDminShrinker >> asInput: array [

	^ array
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> ensureOneMinimal: lmin upperBound: bound [

	lmin do: [ :element | | complement |
		complement := lmin reject: [ :each | each = element ].
		self minimizationDone.
		(self triggerBug: complement upperBound: bound)
			ifTrue: [ ^ self ensureOneMinimal: complement upperBound: bound ]
			ifFalse: [ self failedMinimization ]
	].

	^ lmin
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> minimizeOne: list upperBound: bound [

	list size <= 1 ifTrue: [ ^ list ].

	source := list.
	^ self minimizeWDDmin: (1 to: list size) asArray weights: (self newWeights: list) upperBound: bound
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> minimizeWDDmin: indices weights: weights upperBound: bound [

	| lmin |

	lmin := self wddRec: (self weightedPartitions: { indices } weights: weights) lmin: indices weights: weights upperBound: bound.

	lmin := self ensureOneMinimal: lmin upperBound: bound.

	^ self elementsOf: source at: lmin
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> newWeights: list [

	"Weights are indexed by position. Every element of a flat list is one item of size 1,
	so the weights are uniform; structure-aware weights live in ShinSADDShrinker."

	| weight |

	weight := (1 / list size) asFloat.

	^ (1 to: list size) inject: Dictionary new into: [ :dict :index |
		dict at: index put: weight.
		dict
	]
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> sizeOf: string [

	^ string size
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> splits: ptn with: halfSum weights: weights [
	"split ptn into two paritions with weight sum of each close to halfSum"

	| pairs part1 part2 sum1 sum2 |

	pairs := ptn asArray collect: [ :index | { index . (weights at: index) } ].
	pairs := pairs sorted: [ :a :b | a second > b second ].

	part1 := OrderedCollection new.
	part2 := OrderedCollection new.
	sum1 := 0.
	sum2 := 0.

	pairs do: [ :pair | | item weight |
		item := pair first.
		weight := pair second.
		sum1 <= sum2 ifTrue: [
			part1 add: item . sum1 := sum1 + weight ] ifFalse: [
			part2 add: item . sum2 := sum2 + weight ]
		].

	^ { part1 asSortedCollection asArray . part2 asSortedCollection asArray }
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> tree: aString [

	^ aString
]

{ #category : 'testing' }
ShinWDDminShrinker >> triggerBug: indices upperBound: originalScore [

	^ oracle accepts: (self asInput: (self elementsOf: source at: indices)) from: originalScore
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> wddRec: partitions lmin: lmin weights: weights upperBound: bound [

	| localPartitions |

	localPartitions := partitions.

	[ true ] whileTrue: [ | refined |
		"Reduce to subset (a single partition is lmin itself, nothing to test)"
		localPartitions size > 1 ifTrue: [
			localPartitions do: [ :ptn |
				self minimizationDone.
				(self triggerBug: ptn upperBound: bound) ifTrue: [
					^ self wddRec: (self weightedPartitions: { ptn } weights: weights) lmin: ptn weights: weights upperBound: bound
				] ifFalse: [ self failedMinimization ]
			] ].

		"Reduce to complement (with two partitions the complements are the subsets just tested)"
		localPartitions size > 2 ifTrue: [
			localPartitions do: [ :ptn | | toRemove complement |
				toRemove := ptn asSet.
				complement := lmin reject: [ :index | toRemove includes: index ].
				self minimizationDone.
				(self triggerBug: complement upperBound: bound) ifTrue: [
					^ self wddRec: (localPartitions reject: [ :e | e == ptn ]) lmin: complement weights: weights upperBound: bound
				] ifFalse: [ self failedMinimization ]
			] ].

		"Increase granularity, stop once every partition is a singleton"
		refined := self weightedPartitions: localPartitions weights: weights.
		refined size = localPartitions size ifTrue: [ ^ lmin ].
		localPartitions := refined
	]
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> weightedPartitions: partitions weights: weights [

	"Split every partition with more than one element in two halves of similar weight.
	Singletons are kept so they can still be tested at the finest granularity."

	| result |

	result := OrderedCollection new.

	partitions do: [ :ptn |
		ptn size > 1
			ifTrue: [ | halfSum |
				halfSum := 0.5 * ((ptn asArray collect: [ :e | weights at: e ]) sum).
				result addAll: (self splits: ptn with: halfSum weights: weights) ]
			ifFalse: [ result add: ptn ] ].

	^ result

]
