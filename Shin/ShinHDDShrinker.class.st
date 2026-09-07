Class {
	#name : 'ShinHDDShrinker',
	#superclass : 'ShinGrammarShrinker',
	#instVars : [
		'ddMin',
		'seen',
		'ddmin'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinHDDShrinker >> currentChildrenAssociations: tree atLevel: level [

	^ (tree allNodesAtLevel: level) inject: Dictionary new into: [ :dict :child |
			child parent ifNotNil: [ dict at: child parent ifAbsentPut: child parent children copy ].
			dict
		]
]

{ #category : 'shrinking' }
ShinHDDShrinker >> ddmin: candidates upperBound: bound [

	^ ddmin minimizeOne: candidates upperBound: bound
]

{ #category : 'testing' }
ShinHDDShrinker >> grammar: aGrammar [

	super grammar: aGrammar.
	ddmin grammar: aGrammar
]

{ #category : 'shrinking' }
ShinHDDShrinker >> hddmin: tree upperBound: bound level: level [
	
		| candidates minimized currentChildren |
		
		candidates := tree allNodesAtLevel: level.

		(candidates size <= 1) ifTrue: [ ^ nil ].
		
		currentChildren := self currentChildrenAssociations: tree atLevel: level.
	
		ddmin oracle: (ShinBooleanInputOracle from: [ :possibleNewChilds | | toDelete trigger |
			toDelete := candidates difference: possibleNewChilds.
			toDelete do: [ :childToDelete | | parent |
				parent := childToDelete parent.
				parent ifNotNil: [ parent removeChild: childToDelete ]
			].
			
			trigger := self triggerBug: tree upperBound: bound.
			trigger ifFalse: [
				currentChildren keysDo: [ :parent |
					parent children: (OrderedCollection withAll: (currentChildren at: parent))
				]
			] ifTrue: [
				currentChildren := self currentChildrenAssociations: tree atLevel: level.
			].
			trigger
		]).
		
		"DDMIN classic"
		minimized := self ddmin: candidates upperBound: bound.

		(candidates difference: minimized) do: [ :childToDelete | | parent |
			parent := childToDelete parent.
			parent ifNotNil: [ parent removeChild: childToDelete ]
		].
]

{ #category : 'shrinking' }
ShinHDDShrinker >> initialize [ 

	super initialize.
	seen := Set new.
	"ddmin := ShinDDminPaperCustomShrinker new caller: self."
	ddmin := ShinFuzzingBookPaperCustomShrinker new caller: self.
	
]

{ #category : 'shrinking' }
ShinHDDShrinker >> minimizeOne: originalTree upperBound: bound [

	| currentLevel tree |

	tree := self tree: originalTree asInput.
	
	tree ifNil: [ ^ originalTree ].
	
	currentLevel := 1.
   [ currentLevel <= tree treeHeight ] whileTrue: [
		self hddmin: tree upperBound: bound level: currentLevel.		
		currentLevel := currentLevel + 1.
	].

	^ tree
]

{ #category : 'shrinking' }
ShinHDDShrinker >> oracle: anOracle [

	super oracle: anOracle.
]

{ #category : 'shrinking' }
ShinHDDShrinker >> seen [

	^ seen
]

{ #category : 'shrinking' }
ShinHDDShrinker >> seen: aInput [

	seen := aInput 
]

{ #category : 'shrinking' }
ShinHDDShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]
