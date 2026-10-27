"
Input minimization of Nautilus, as described in the paper (Aschermann et al., NDSS 2019, section IV-B
""Minimization"") and implemented in the reference fuzzer (`minimize_tree` and `minimize_rec` in
https://github.com/nautilus-fuzz/nautilus, grammartec/src/mutator.rs).

Two passes are applied one after the other:

1. Subtree minimization: every node, in pre-order and including the root, whose subtree is bigger
   than the smallest derivation of its non-terminal is replaced by that smallest derivation. The
   replacement is kept if the oracle still accepts the input, otherwise it is undone.
2. Recursive minimization: for every node, the nearest ancestor with the same non-terminal (at any
   distance) is replaced by the node's subtree. After a successful replacement the pass continues
   right after the position of that ancestor.
"
Class {
	#name : 'ShinNautilusPaperShrinker',
	#superclass : 'ShinGrammarShrinker',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinNautilusPaperShrinker >> isMinimizable: node [

	"minimize_tree only tries a node when its subtree is bigger than the minimal length of its non-terminal"

	| nonTerminal |
	node isLeaf ifTrue: [ ^ false ].
	nonTerminal := self nonTerminalNamed: node tag.
	nonTerminal ifNil: [ ^ false ].
	^ (self sizeOf: node) > nonTerminal minSize
]

{ #category : 'shrinking' }
ShinNautilusPaperShrinker >> minimizeOne: givenTree upperBound: bound [

	| tree |
	tree := self tree: givenTree asInput.
	tree ifNil: [ ^ givenTree ].

	tree := self subtreeMinimization: tree upperBound: bound.
	^ self recursiveMinimization: tree upperBound: bound
]

{ #category : 'shrinking' }
ShinNautilusPaperShrinker >> nearestAncestorOf: node [

	"find_parent_with_nt: the closest ancestor derived from the same non-terminal"

	| current |
	node isLeaf ifTrue: [ ^ nil ].
	(self nonTerminalNamed: node tag) ifNil: [ ^ nil ].

	current := node parent.
	[ current notNil ] whileTrue: [
		current tag asString = node tag asString ifTrue: [ ^ current ].
		current := current parent ].
	^ nil
]

{ #category : 'shrinking' }
ShinNautilusPaperShrinker >> recursiveMinimization: aTree upperBound: bound [

	"minimize_rec"

	| tree nodes index |
	tree := aTree.
	nodes := tree allNodes.
	index := 1.

	[ index <= nodes size ] whileTrue: [ | node ancestor |
		node := nodes at: index.
		ancestor := self nearestAncestorOf: node.

		ancestor ifNotNil: [ | candidate |
			candidate := self replace: ancestor by: (self copyTree: node) in: tree upperBound: bound.
			candidate ifNotNil: [
				"continue right after the replaced ancestor, whose position did not change"
				index := nodes identityIndexOf: ancestor.
				tree := candidate.
				nodes := tree allNodes ] ].

		index := index + 1 ].

	^ tree
]

{ #category : 'shrinking' }
ShinNautilusPaperShrinker >> replace: node by: replacement in: tree upperBound: bound [

	"Replace node by replacement in tree. Answer the resulting tree if the oracle still accepts it,
	otherwise undo the replacement and answer nil."

	| parent index |
	self minimizationDone.

	parent := node parent.
	parent ifNil: [
		"the root: the replacement becomes the whole tree"
		(self triggerBug: replacement upperBound: bound) ifTrue: [ ^ replacement ].
		self failedMinimization.
		^ nil ].

	index := parent children identityIndexOf: node.
	parent replaceChildAt: index with: replacement.
	(self triggerBug: tree upperBound: bound) ifTrue: [ ^ tree ].

	self failedMinimization.
	parent replaceChildAt: index with: node.
	^ nil
]

{ #category : 'shrinking' }
ShinNautilusPaperShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]

{ #category : 'shrinking' }
ShinNautilusPaperShrinker >> subtreeMinimization: aTree upperBound: bound [

	"minimize_tree"

	| tree nodes index |
	tree := aTree.
	nodes := tree allNodes.
	index := 1.

	[ index <= nodes size ] whileTrue: [ | node |
		node := nodes at: index.

		(self isMinimizable: node) ifTrue: [ | candidate |
			candidate := self replace: node by: (self minimized: node) in: tree upperBound: bound.
			candidate ifNotNil: [
				"the next positions are the nodes of the minimal subtree, then the rest of the tree"
				tree := candidate.
				nodes := tree allNodes ] ].

		index := index + 1 ].

	^ tree
]
