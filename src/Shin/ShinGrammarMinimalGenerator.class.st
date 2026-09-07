Class {
	#name : 'ShinGrammarMinimalGenerator',
	#superclass : 'GncVisitor',
	#instVars : [
		'grammar',
		'randomGenerator'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'accessing' }
ShinGrammarMinimalGenerator >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'initialization' }
ShinGrammarMinimalGenerator >> initialize [

	super initialize.
	randomGenerator := GncPCGRandomGenerator new
]

{ #category : 'initialization' }
ShinGrammarMinimalGenerator >> random [

	^ randomGenerator
]

{ #category : 'visiting' }
ShinGrammarMinimalGenerator >> selectRule: rules [

	^ (rules sorted: [ :a :b | a minSize < b minSize ]) first
]

{ #category : 'visiting' }
ShinGrammarMinimalGenerator >> visitNonTerminal: nonTerminal [

	| rule |
	
	rule := self selectRule: nonTerminal rules.
	
	^ (rule visit: self) tag: nonTerminal name
]

{ #category : 'visiting' }
ShinGrammarMinimalGenerator >> visitRule: rule [
	
	^ GncInnerNode with: (rule fragments collect: [ :fragment | (fragment visit: self) grammarRule: rule; yourself ])
]

{ #category : 'visiting' }
ShinGrammarMinimalGenerator >> visitTerminal: terminal [

	^ terminal generateAst: self
]
