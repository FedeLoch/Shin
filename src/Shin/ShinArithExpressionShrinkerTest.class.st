Class {
	#name : 'ShinArithExpressionShrinkerTest',
	#superclass : 'ShinGrammarBasedShrinkerTest',
	#instVars : [
		'shrinker'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'running' }
ShinArithExpressionShrinkerTest >> setUp [ 
	
	super setUp.
	self timeLimit: 5 hours.
	shrinker := ShinNautilusShrinker new.
	shrinker grammar: AritExpressionGrammar new.
]

{ #category : 'running' }
ShinArithExpressionShrinkerTest >> testMinimizeSimpleExpression [

	| node |
	
	node := self tree: '(2+2)/0'.
	
	"'(2+2)/0' -> '1/0'"
	self assert: (shrinker minimized: node) asInput size equals: 1
]

{ #category : 'running' }
ShinArithExpressionShrinkerTest >> testMinimizeSimpleExpression1 [

	| node |
	
	node := self tree: '1+(2*3)'.

	self assert: (shrinker minimized: node) asInput size equals: 1
]

{ #category : 'running' }
ShinArithExpressionShrinkerTest >> tree: input [

	^ UmeGrammarParser parse: input from: shrinker grammar
]
