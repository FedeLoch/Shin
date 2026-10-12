Class {
	#name : 'ShinNautilusShrinker',
	#superclass : 'ShinGrammarShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinNautilusShrinker >> candidates: root [
	
	| worstReward worst |
	worstReward := SmallInteger maxVal.
	worst := OrderedCollection new.
	
	root allNodes do: [ :node | | reward |
		reward := node reward: grammar root: root.
		(reward < worstReward) ifTrue: [ worstReward := reward . worst := OrderedCollection new ].
		(reward = worstReward) ifTrue: [ worst add: node ]
	].

	^ worst
]

{ #category : 'shrinking' }
ShinNautilusShrinker >> isAttached: node to: root [

	"A node stops being part of the tree when one of its ancestors was replaced"

	| current |
	current := node.
	[ current == root ] whileFalse: [
		(current parent isNil or: [ (current parent children includes: current) not ]) ifTrue: [ ^ false ].
		current := current parent ].
	^ true
]

{ #category : 'shrinking' }
ShinNautilusShrinker >> minimizeOne: givenTree upperBound: upperBound [

	| tree |

	tree := self tree: givenTree asInput.

	(self candidates: tree) do: [ :candidate | | parent |
		parent := candidate parent.

		(parent notNil and: [ self isAttached: candidate to: tree ]) ifTrue: [ | minimal reduced |
			reduced := false.
			minimal := self minimized: candidate.

			"trying to replace the candidate by its minimal derivation"
			minimal asInput = candidate asInput ifFalse: [ | index |
				index := parent children indexOf: candidate.
				parent replaceChildAt: index with: minimal.
				self minimizationDone.
				reduced := self triggerBug: tree upperBound: upperBound.
				reduced ifFalse: [
					self failedMinimization.
					parent replaceChildAt: index with: candidate ] ].

			"trying to replace the parent by candidate in case they have the same symbol"
			(reduced not and: [ parent tag = candidate tag and: [ candidate isLeaf not ] ]) ifTrue: [ | parentChildren candidateChildren |
				parentChildren := parent children copy.
				candidateChildren := candidate children.

				self setChildrenOf: parent to: candidateChildren.
				self minimizationDone.

				(self triggerBug: tree upperBound: upperBound) ifFalse: [
					self failedMinimization.
					self setChildrenOf: parent to: parentChildren.
					candidate children: candidateChildren ] ] ] ].

	^ tree 
]

{ #category : 'shrinking' }
ShinNautilusShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]
