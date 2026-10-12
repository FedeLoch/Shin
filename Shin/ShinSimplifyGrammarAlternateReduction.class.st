Class {
	#name : 'ShinSimplifyGrammarAlternateReduction',
	#superclass : 'ShinShrinkingStrategy',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'enumerating' }
ShinSimplifyGrammarAlternateReduction class >> alternateReduction: aTree using: aGrammar matchingWith: symbol [
	" return all the reduction candidates"

	^ self
		  alternateReduction: aTree
		  using: aGrammar
		  matchingWith: symbol
		  subtreesFinder: [ :treeCopy :altSymbol | ShinSimplifyGrammarSubtreeReducer findSubtree: treeCopy mathchingWith: altSymbol name ]
]

{ #category : 'enumerating' }
ShinSimplifyGrammarAlternateReduction class >> alternateReduction: aTree using: aGrammar matchingWith: symbol depth: depth [

	" return all the reduction candidates"

	^ self
		  alternateReduction: aTree
		  using: aGrammar
		  matchingWith: symbol
		  subtreesFinder: [ :treeCopy :altSymbol | ShinSimplifyGrammarSubtreeReducer findSubtree: treeCopy mathchingWith: altSymbol name depth: depth ]
]

{ #category : 'enumerating' }
ShinSimplifyGrammarAlternateReduction class >> alternateReduction: aTree using: aGrammar matchingWith: symbol subtreesFinder: finderBlock [

	"For every expansion of symbol, build the trees whose non-terminal fragments are taken
	from matching subtrees of aTree and whose terminal fragments are regenerated, keeping
	the fragments in the order of the expansion."

	| expansions reductions nonTerminal generator |

	reductions := OrderedCollection new.
	generator := ShinGrammarMinimalGenerator new grammar: aGrammar; yourself.
	nonTerminal := aGrammar instVarNamed: ('nt' , symbol asString).
	expansions := nonTerminal rules.
	expansions := expansions sorted: [ :expA :expB | expA fragments size < expB fragments size ]. 
	
	expansions do: [ :expansion | | match options |
		match := true.
		options := OrderedCollection new.
		expansion fragments do: [ :altSymbol | | childReductions |
			match ifTrue: [
				childReductions := altSymbol isTerminal
					ifTrue: [ { (altSymbol generateAst: generator) grammarRule: expansion; yourself } ]
					ifFalse: [ finderBlock value: aTree doCopy value: altSymbol ].
				childReductions ifEmpty: [ match := false ].
				options add: childReductions ] ].
		
		"an expansion made only of terminals reuses nothing from aTree"
		(match and: [ expansion fragments anySatisfy: [ :fragment | fragment isTerminal not ] ]) ifTrue: [
			(self possibleCombination: options) do: [ :combination | | newTree |
				newTree := self buildNewTree: combination tag: symbol.
				newTree treeSize < aTree treeSize ifTrue: [ reductions add: newTree ] ] ]
	].

	^ reductions
]

{ #category : 'enumerating' }
ShinSimplifyGrammarAlternateReduction class >> buildNewTree: aCombination tag: aSymbol [
	
	| newSubTree |
	
	newSubTree := GncInnerNode new.
	newSubTree tag: aSymbol.
	newSubTree children: aCombination.
	
	^ newSubTree
]

{ #category : 'as yet unclassified' }
ShinSimplifyGrammarAlternateReduction class >> possibleCombination: aListOfLists [

	| allCombinationsList |
	
	aListOfLists ifNil: [ ^nil ].
	aListOfLists ifEmpty: [ ^ OrderedCollection new ].
	allCombinationsList := OrderedCollection with: OrderedCollection new.
	
	aListOfLists do: [ :aSubList | |res|
		res := OrderedCollection new.
		allCombinationsList do: [ :combinations | 
			aSubList do: [ :element |
				res add: (combinations copy add: element; yourself )]
			].
		allCombinationsList := res.
		].
	^ allCombinationsList 
]

{ #category : 'as yet unclassified' }
ShinSimplifyGrammarAlternateReduction class >> reduce: subtree using: grammar matching: symbol [

	^ self alternateReduction: subtree using: grammar matchingWith: symbol
]

{ #category : 'as yet unclassified' }
ShinSimplifyGrammarAlternateReduction class >> reduce: subtree using: grammar matching: symbol depth: depth [

	^ self alternateReduction: subtree using: grammar matchingWith: symbol depth: depth
]
