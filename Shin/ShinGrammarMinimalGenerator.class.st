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
	self reset
]

{ #category : 'initialization' }
ShinGrammarMinimalGenerator >> random [

	^ randomGenerator
]

{ #category : 'initialization' }
ShinGrammarMinimalGenerator >> reset [

	"A fixed seed keeps reductions reproducible: the default generator is clock seeded,
	so terminal ranges (e.g. digits) would get different values on every run"
	randomGenerator := GncPCGRandomGenerator seed: 42
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
