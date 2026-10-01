Class {
	#name : 'ShinWDDminShrinker',
	#superclass : 'ShinShrinker',
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
		complement := lmin \ { element }.

		(self triggerBug: complement upperBound: bound) ifTrue: [
			^ self ensureOneMinimal: complement upperBound: bound
		]
	].

	^ lmin
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> minimizeOne: list upperBound: bound [

	^ self minimizeWDDmin: list weights: (self newWeights: list) upperBound: bound
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> minimizeWDDmin: list weights: weights upperBound: bound [

	| lmin |

	lmin := self wddRec: {list} lmin: list input: list weights: weights upperBound: bound.
	
	lmin := self ensureOneMinimal: lmin upperBound: bound.
	
	^ list class withAll: lmin
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> newWeights: list [

	| weight |
	
	weight := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :_ |
		dict at: _ put: weight.
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
	
	pairs := (1 to: ptn size) collect: [ :i | { (ptn at: i) . (weights at: (ptn at: i)) } ].
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

	^ { part1 . part2 }
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> tree: aString [

	^ aString
]

{ #category : 'testing' }
ShinWDDminShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> wddRec: partitions lmin: lmin input: list upperBound: bound [

	[ partitions notEmpty ] whileTrue: [
		partitions do: [ :ptn |
			
		
		]
	]
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> wddRec: partitions lmin: lmin input: list weights: weights upperBound: bound [

	| localPartitions |
	
	localPartitions := partitions.

	[ localPartitions notEmpty ] whileTrue: [ 
		partitions do: [ :ptn |
			(self triggerBug: ptn upperBound: bound) ifTrue: [ | currentLmin currentPartitions |
				currentLmin := ptn.
				currentPartitions := self weightedPartitions: { ptn } weights: weights.
				^ self wddRec: currentPartitions lmin: currentLmin input: list weights: weights upperBound: bound
			]
		].
	
		localPartitions do: [ :ptn | | complement |
			complement := lmin \ { ptn }.
			(self triggerBug: complement upperBound: bound) ifTrue: [ | currentLmin currentPartitions |
				currentLmin := complement.
				currentPartitions := localPartitions reject: [ :e | e = ptn ].
				^ self wddRec: currentPartitions lmin: currentLmin input: list weights: weights upperBound: bound
			]
		].
			
		localPartitions := self weightedPartitions: localPartitions weights: weights
	].

	^ lmin
]

{ #category : 'shrinking' }
ShinWDDminShrinker >> weightedPartitions: partitions weights: weights [

	| result |
		
	result := OrderedCollection new.
	
	(partitions select: [ :ptn | ptn size > 1 ]) do: [ :ptn | | halfSum parts |
		halfSum := 0.5 * ((ptn asArray collect: [ :e | weights at: e ]) sum).
		parts := self splits: ptn with: halfSum weights: weights.
		result addAll: parts
	].

	^ result
	
]
