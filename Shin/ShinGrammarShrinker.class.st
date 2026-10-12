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

	"Answer the smallest derivation of the node's symbol. The node's grammarRule is the
	production of its parent (the rule the node is a fragment of), so the minimal tree is
	generated from the non-terminal named by the node's tag instead. Leaves and unknown
	symbols cannot be minimized and are answered as a copy."

	| nonTerminal newNode |

	nonTerminal := self nonTerminalNamed: node tag.
	nonTerminal ifNil: [ ^ self copyTree: node ].

	newNode := nonTerminal visit: minimalGenerator.
	newNode tag: node tag.
	newNode grammarRule: node grammarRule.

	^ newNode
]

{ #category : 'shrinking' }
ShinGrammarShrinker >> nonTerminalNamed: aTag [

	aTag ifNil: [ ^ nil ].
	grammar eachNonTerminal: [ :nonTerminal |
		nonTerminal name asString = aTag asString ifTrue: [ ^ nonTerminal ] ].
	^ nil
]

{ #category : 'testing' }
ShinGrammarShrinker >> parse: input [

	^ GncGenericGrammarParser parse: input from: grammar
]

{ #category : 'shrinking' }
ShinGrammarShrinker >> resetState [

	super resetState.
	minimalGenerator reset
]

{ #category : 'shrinking' }
ShinGrammarShrinker >> tree: input [

	^ self parse: input
]
