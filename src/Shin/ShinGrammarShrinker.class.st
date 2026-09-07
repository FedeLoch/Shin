Class {
	#name : 'ShinGrammarShrinker',
	#superclass : 'ShinShrinker',
	#instVars : [
		'minimalGenerator'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinGrammarShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'testing' }
ShinGrammarShrinker >> copyTree: tree [
 
	^ tree doCopy
]

{ #category : 'testing' }
ShinGrammarShrinker >> grammar: aGrammar [

	super grammar: aGrammar.
	minimalGenerator grammar: aGrammar
]

{ #category : 'testing' }
ShinGrammarShrinker >> initialize [ 
	
	super initialize.
	minimalGenerator := ShinGrammarMinimalGenerator new.
]

{ #category : 'testing' }
ShinGrammarShrinker >> isValidTree: tree [

	| input derivation |
	input := tree asInput.

	[ derivation := self parse: input ] on: Error do: [ ^ false ].
	derivation ifNil: [ ^ false ].

	^ derivation asInput = input
]

{ #category : 'shrinking' }
ShinGrammarShrinker >> minimized: node [

	| newNode |
	
	newNode := node grammarRule visit: minimalGenerator.
	newNode tag: node	tag.
	newNode grammarRule: node grammarRule.

	^ newNode
]

{ #category : 'testing' }
ShinGrammarShrinker >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'shrinking' }
ShinGrammarShrinker >> tree: input [

	^ self parse: input
]
