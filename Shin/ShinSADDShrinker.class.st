Class {
	#name : 'ShinSADDShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'pu',
		'pb',
		'c',
		'weights',
		'levelOracle'
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

{ #category : 'shrinking' }
ShinSADDShrinker >> currentChildrenAssociations: tree atLevel: level [

	^ (tree allNodesAtLevel: level) inject: Dictionary new into: [ :dict :child |
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
ShinSADDShrinker >> entropyOf: decisionNode [

	| total |
	total := self leavesOf: decisionNode.

	^ decisionNode children inject: 0 into: [ :sum :child | | p |
		  p := (self leavesOf: child) / total.
		  sum - (p * p ln) ]
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
	c := 16
]

{ #category : 'shrinking' }
ShinSADDShrinker >> leavesOf: node [

	node isLeaf ifTrue: [ ^ 1 ].

	^ node children inject: 0 into: [ :sum :child | sum + (self leavesOf: child) ]
]

{ #category : 'shrinking' }
ShinSADDShrinker >> minimizeOne: originalTree upperBound: bound [

	| tree currentLevel |

	tree := self tree: originalTree asInput.
	tree ifNil: [ ^ originalTree ].

	currentLevel := 1.
	[ currentLevel <= tree treeHeight ] whileTrue: [
		self reduceLevel: tree upperBound: bound level: currentLevel.
		currentLevel := currentLevel + 1 ].

	^ tree
]

{ #category : 'shrinking' }
ShinSADDShrinker >> reduceCandidates: list upperBound: bound [

	self subclassResponsibility
]

{ #category : 'shrinking' }
ShinSADDShrinker >> reduceLevel: tree upperBound: bound level: level [

	| candidates currentChildren minimized |

	candidates := tree allNodesAtLevel: level.
	candidates size <= 1 ifTrue: [ ^ nil ].

	currentChildren := self currentChildrenAssociations: tree atLevel: level.
	weights := self weightsOf: candidates.

	levelOracle := ShinBooleanInputOracle from: [ :possibleNewChilds | | toDelete trigger |
		toDelete := candidates difference: possibleNewChilds.
		toDelete do: [ :childToDelete | | parent |
			parent := childToDelete parent.
			parent ifNotNil: [ parent removeChild: childToDelete ] ].

		trigger := self triggerBug: tree upperBound: bound.
		trigger
			ifFalse: [ currentChildren keysDo: [ :parent |
				  parent children: (OrderedCollection withAll: (currentChildren at: parent)) ] ]
			ifTrue: [ currentChildren := self currentChildrenAssociations: tree atLevel: level ].
		trigger ].

	[ minimized := self reduceCandidates: candidates upperBound: bound.
	(candidates difference: minimized) do: [ :childToDelete | | parent |
		parent := childToDelete parent.
		parent ifNotNil: [ parent removeChild: childToDelete ] ] ]
		ensure: [ levelOracle := nil ].

	^ minimized
]

{ #category : 'shrinking' }
ShinSADDShrinker >> saturationFunction: x [

	^ x / (x + c)
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

	(anObject isCollection and: [ levelOracle notNil ])
		ifTrue: [ ^ levelOracle accepts: anObject from: originalScore ].

	^ super triggerBug: anObject upperBound: originalScore
]

{ #category : 'shrinking' }
ShinSADDShrinker >> weightsOf: aCollection [

	^ aCollection inject: Dictionary new into: [ :dict :node |
		  dict at: node put: (self structuralWeightOf: node).
		  dict ]
]
