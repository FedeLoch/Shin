Class {
	#name : 'ShinSimplifyGrammarSubtreeReducerTest',
	#superclass : 'ShinReductionShrinkerTest',
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'tests' }
ShinSimplifyGrammarSubtreeReducerTest >> testMinimizingAnExpressionSubree [

	| expressionTree grammar res stringList expectedRes|
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '1+(2*3)' from: grammar.
	res := (ShinSimplifyGrammarSubtreeReducer findSubtree: expressionTree mathchingWith: 'Term' ).
	stringList := res collect: #asInput.
	expectedRes := #('(2*3)' '1' '2' '3').
	
	self assert: (stringList includesAll: expectedRes).
]

{ #category : 'tests' }
ShinSimplifyGrammarSubtreeReducerTest >> testMinimizingAnExpressionSubree02 [

	| expressionTree grammar res stringList expectedRes|
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '1+(2*3)' from: grammar.
	res := (ShinSimplifyGrammarSubtreeReducer findSubtree: expressionTree mathchingWith: 'Op' ).
	stringList := res collect: #asInput.
	expectedRes := #('+' '*').
	
	self assert: (stringList includesAll: expectedRes).
]
