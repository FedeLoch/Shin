Class {
	#name : 'UmeGrammarBasedShrinkerTest',
	#superclass : 'TestCase',
	#instVars : [
		'feedbackEvaluator'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'tests' }
UmeGrammarBasedShrinkerTest >> updateFeedbackEvaluatorWith: feedback [

	feedbackEvaluator guide setBase: feedback.

]
