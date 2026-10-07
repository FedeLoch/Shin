Class {
	#name : 'ShinSADDShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'pu',
		'pb',
		'c',
		'weights',
		'seen',
		'candidateOracle',
		'caller'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinSADDShrinker >> backgroundPerplexity: node [

	| numerator denominator |
	numerator := 0.
	denominator := 0.

	self decisionNodesOf: node do: [ :decisionNode | | nodeLeaves entropy |
		nodeLeaves := self leavesOf: decisionNode.
		entropy := self entropyOf: decisionNode.
		numerator := numerator + (nodeLeaves * (entropy exp - 1)).
		denominator := denominator + nodeLeaves ].

	denominator = 0 ifTrue: [ ^ 0 ].

	^ numerator / denominator
]

{ #category : 'accessing' }
ShinSADDShrinker >> caller [

	^ caller
]

{ #category : 'accessing' }
ShinSADDShrinker >> caller: aCaller [

	caller := aCaller
]

{ #category : 'shrinking' }
ShinSADDShrinker >> childrenAssociations: nodeList [

	"Snapshot the current children of every parent of the given nodes, so a failed
	reduction can be rolled back."

	^ nodeList inject: Dictionary new into: [ :dict :child |
		  child parent ifNotNil: [ dict at: child parent ifAbsentPut: child parent children copy ].
		  dict
	  ]
]

{ #category : 'shrinking' }
ShinSADDShrinker >> decisionNodesOf: node do: aBlock [

	| children |
	node isLeaf ifTrue: [ ^ self ].

	children := node children.
	children size >= 2 ifTrue: [ aBlock value: node ].
	children do: [ :child | self decisionNodesOf: child do: aBlock ]
]

{ #category : 'shrinking' }
ShinSADDShrinker >> decisionUniformity: node [

	| numerator denominator |
	numerator := 0.
	denominator := 0.

	self decisionNodesOf: node do: [ :decisionNode | | nodeLeaves arity |
		nodeLeaves := self leavesOf: decisionNode.
		arity := decisionNode children size.
		numerator := numerator + (nodeLeaves * ((self entropyOf: decisionNode) / arity ln)).
		denominator := denominator + nodeLeaves ].

	denominator = 0 ifTrue: [ ^ 0 ].

	^ numerator / denominator
]

{ #category : 'shrinking' }
ShinSADDShrinker >> ddvalue: element probabilities: probs [

	^ (weights at: element) * (1 - (probs at: element))
]

{ #category : 'shrinking' }
ShinSADDShrinker >> ensureOneMinimal: lmin upperBound: bound [

	lmin do: [ :element | | complement |
		complement := lmin \ { element }.

		(self triggerBug: complement upperBound: bound) ifTrue: [
			^ self ensureOneMinimal: complement upperBound: bound
		]
	].

	^ lmin
]

{ #category : 'shrinking' }
ShinSADDShrinker >> entropyOf: decisionNode [

	| total |
	total := self leavesOf: decisionNode.

	^ decisionNode children inject: 0 into: [ :sum :child | | p |
		  p := (self leavesOf: child) / total.
		  sum - (p * p ln) ]
]

{ #category : 'shrinking' }
ShinSADDShrinker >> failedMinimization [

	super failedMinimization.
	caller ifNotNil: [ caller failedMinimization ]
]

{ #category : 'shrinking' }
ShinSADDShrinker >> flatElementsOf: node into: aCollection [

	"All non-root nodes of the tree in pre-order; each is an element of the flat list."

	node children do: [ :child |
		aCollection add: child.
		self flatElementsOf: child into: aCollection ].

	^ aCollection
]

{ #category : 'shrinking' }
ShinSADDShrinker >> flatElementsOf: tree [

	^ self flatElementsOf: tree into: OrderedCollection new
]

{ #category : 'shrinking' }
ShinSADDShrinker >> geometricVolume: node [

	^ node treeHeight * (self leavesOf: node)
]

{ #category : 'shrinking' }
ShinSADDShrinker >> initialize [

	super initialize.
	pu := 1.
	pb := 1.
	c := 16.
	seen := Set new
]

{ #category : 'shrinking' }
ShinSADDShrinker >> leavesOf: node [

	node isLeaf ifTrue: [ ^ 1 ].

	^ node children inject: 0 into: [ :sum :child | sum + (self leavesOf: child) ]
]

{ #category : 'shrinking' }
ShinSADDShrinker >> minimizeOne: originalTree upperBound: bound [

	| tree elements childrenSnapshot |

	"In HDD per-level strategy mode the argument is the list of candidate nodes of a
	level; the oracle was already installed by ShinHDDShrinker."
	originalTree isCollection ifTrue: [
		weights := self weightsOf: originalTree.
		^ self reduceCandidates: originalTree upperBound: bound ].

	"Standalone flat mode over the whole parse tree."
	tree := self tree: originalTree asInput.
	tree ifNil: [ ^ originalTree ].

	elements := self flatElementsOf: tree.
	elements size <= 1 ifTrue: [ ^ tree ].

	weights := self weightsOf: elements.
	childrenSnapshot := self childrenAssociations: elements.

	candidateOracle := ShinBooleanInputOracle from: [ :keptNodes | | toDelete trigger |
		toDelete := elements difference: keptNodes.
		toDelete do: [ :node | | parent |
			parent := node parent.
			parent ifNotNil: [ parent removeChild: node ] ].

		trigger := self triggerBug: tree upperBound: bound.
		trigger
			ifFalse: [ childrenSnapshot keysDo: [ :parent |
				  parent children: (OrderedCollection withAll: (childrenSnapshot at: parent)) ] ]
			ifTrue: [ childrenSnapshot := self childrenAssociations: elements ].
		trigger ].

	[ | minimized |
		minimized := self reduceCandidates: elements upperBound: bound.
		(elements difference: minimized) do: [ :node | | parent |
			parent := node parent.
			parent ifNotNil: [ parent removeChild: node ] ] ]
		ensure: [ candidateOracle := nil ].

	^ tree
]

{ #category : 'shrinking' }
ShinSADDShrinker >> minimizeSADDmin: list weights: aWeights upperBound: bound [

	| lmin totalWeight |

	weights := aWeights.
	totalWeight := weights values sum.
	seen := Set new.

	lmin := self saddmin: list totalWeight: totalWeight upperBound: bound.
	lmin := self ensureOneMinimal: lmin upperBound: bound.

	^ list class withAll: lmin
]

{ #category : 'shrinking' }
ShinSADDShrinker >> minimizeSAProbDD: list probabilities: probs weights: aWeights upperBound: bound [

	| lmin |

	weights := aWeights.
	lmin := list.

	[ lmin anySatisfy: [ :element | (probs at: element) < 1 ] ] whileTrue: [ | subset complement |
		subset := self selectSubset: lmin probabilities: probs.
		complement := lmin \ subset.
		self minimizationDone.
		(self triggerBug: complement upperBound: bound)
			ifTrue: [ lmin := complement ]
			ifFalse: [ | factor |
				self failedMinimization.
				factor := 1 / (1 - ((subset collect: [ :elem | 1 - (probs at: elem) ]) multiply)).
				subset do: [ :elem |
					probs at: elem update: [ :p | factor * p ] ] ] ].

	^ list class withAll: lmin
]

{ #category : 'shrinking' }
ShinSADDShrinker >> minimizationDone [

	super minimizationDone.
	caller ifNotNil: [ caller minimizationDone ]
]

{ #category : 'instance creation' }
ShinSADDShrinker >> probabilities: list [

	| p |

	p := (1 / list size) asFloat.

	^ list inject: Dictionary new into: [ :dict :element |
		dict at: element put: p.
		dict ]
]

{ #category : 'shrinking' }
ShinSADDShrinker >> reduceCandidates: list upperBound: bound [

	self subclassResponsibility
]

{ #category : 'shrinking' }
ShinSADDShrinker >> saddmin: list totalWeight: totalWeight upperBound: bound [

	^ self saddmin2: list totalWeight: totalWeight upperBound: bound granularity: 2
]

{ #category : 'shrinking' }
ShinSADDShrinker >> saddmin2: cFail totalWeight: totalWeight upperBound: bound granularity: n [

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
ShinSADDShrinker >> saturationFunction: x [

	^ x / (x + c)
]

{ #category : 'shrinking' }
ShinSADDShrinker >> selectSubset: lmin probabilities: probs [

	| sorted result prefix currentMaxGain |

	sorted := lmin copy sorted: [ :a :b |
		(self ddvalue: a probabilities: probs) >= (self ddvalue: b probabilities: probs) ].

	result := {}.
	prefix := {}.
	currentMaxGain := 0.

	sorted do: [ :element | | weight probOfDeletion gain |
		prefix := prefix, { element }.
		weight := (prefix collect: [ :subElement | weights at: subElement ]) sum.
		probOfDeletion := (prefix collect: [ :subElement | 1 - (probs at: subElement) ]) multiply.
		gain := weight * probOfDeletion.

		(gain > currentMaxGain)
			ifTrue: [ currentMaxGain := gain. result := prefix ]
			ifFalse: [ ^ result ]
	].

	^ result
]

{ #category : 'shrinking' }
ShinSADDShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]

{ #category : 'shrinking' }
ShinSADDShrinker >> structuralWeightOf: node [

	| geometric decision background |

	geometric := self geometricVolume: node.
	decision := self decisionUniformity: node.
	background := self backgroundPerplexity: node.

	^ geometric * (1 + (pu * decision) + (pb * (self saturationFunction: background))) + 1
]

{ #category : 'shrinking' }
ShinSADDShrinker >> totalWeightOf: aCollection [

	^ aCollection inject: 0 into: [ :sum :element | sum + (weights at: element) ]
]

{ #category : 'testing' }
ShinSADDShrinker >> triggerBug: anObject upperBound: originalScore [

	anObject isCollection
		ifTrue: [
			candidateOracle ifNotNil: [ ^ candidateOracle accepts: anObject from: originalScore ].
			^ oracle accepts: anObject from: originalScore ].

	^ super triggerBug: anObject upperBound: originalScore
]

{ #category : 'shrinking' }
ShinSADDShrinker >> weightBalancedPartitions: list totalWeight: totalWeight count: n [

	| target partitions current currentWeight |

	target := totalWeight / n.
	partitions := OrderedCollection new.
	current := OrderedCollection new.
	currentWeight := 0.

	list do: [ :element | | elementWeight |
		elementWeight := weights at: element.
		(current notEmpty and: [ currentWeight + elementWeight > target ]) ifTrue: [
			partitions add: current.
			current := OrderedCollection new.
			currentWeight := 0 ].
		current add: element.
		currentWeight := currentWeight + elementWeight ].

	current ifNotEmpty: [ partitions add: current ].

	^ partitions
]

{ #category : 'shrinking' }
ShinSADDShrinker >> weightsOf: aCollection [

	^ aCollection inject: Dictionary new into: [ :dict :node |
		  dict at: node put: (self structuralWeightOf: node).
		  dict ]
]