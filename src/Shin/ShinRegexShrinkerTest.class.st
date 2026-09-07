Class {
	#name : 'ShinRegexShrinkerTest',
	#superclass : 'ShinGrammarBasedShrinkerTest',
	#instVars : [
		'shrinker',
		'evaluator'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'tests' }
ShinRegexShrinkerTest >> setUp [ 
	
	super setUp.
	self timeLimit: 5 hours.
	shrinker := ShinNautilusShrinker new.
	shrinker grammar: GncRegexGrammar new.
	evaluator := UmeEvaluator new profilingByMethodCalls.
	shrinker evaluator: evaluator.
	feedbackEvaluator := UmeFeedbackEvaluator new feedbackByMethodsCalls.
	shrinker feedbackEvaluator: feedbackEvaluator.
	shrinker classesToProfile: ((RxMatcher >> #matches:) package definedClasses).
	shrinker programBlock: [ :input | input asRegex matches: (input minimalStringMatching) ].
]

{ #category : 'tests' }
ShinRegexShrinkerTest >> testShrinkCostlyRegex01 [

	self assert: (shrinker shrink: 'ac?ab?ab|.b?aa.?aaab?c?a(ca)?ac?aaab?a?a') equals: 'cab?ab.?aa?(a)?c?aaab?a?a'.

]

{ #category : 'tests' }
ShinRegexShrinkerTest >> testShrinkCostlyRegex02 [

	self assert: (shrinker shrink: 'ac?ab?ab|.b?aa.?aaab?c?a(ca)?ac?aaab?a?a') equals: 'cab?ab.?aa?(a)?c?aaab?a?a'.

]

{ #category : 'tests' }
ShinRegexShrinkerTest >> testShrinkCostlyRegex03 [

	self assert: (shrinker shrink: 'a+(a+a.?(a*.*a?a*a*b?.*aa?a+|a)+a.a)....a') equals: '((a*.*a?a*a*.*aa)+a.a)....a'.

]
