Class {
	#name : 'ShinFeedbackTableOracle',
	#superclass : 'ShinInputOracle',
	#instVars : [
		'threshold',
		'programBlock',
		'classesToProfile',
		'feedbackEvaluator',
		'evaluator',
		'memo'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinFeedbackTableOracle >> accepts: score from: upperBound [

	score ifNil: [ ^ false ].

	^ score >= (upperBound * threshold)
]

{ #category : 'testing' }
ShinFeedbackTableOracle >> classesToProfile [

	^ classesToProfile 
]

{ #category : 'testing' }
ShinFeedbackTableOracle >> classesToProfile: someClassesToProfile [

	classesToProfile := someClassesToProfile 
]

{ #category : 'shrinking' }
ShinFeedbackTableOracle >> evalInput: input [

	| profilingResult umeCase program |
	
	memo at: input ifAbsentPut: [
		program := PBAProgram from: [ programBlock value: input ] forClasses: classesToProfile.

		[ 	profilingResult := evaluator analyzer analyze: program.
			umeCase := UmeTest new result: (UmeEvalSuccess new profilingResult: profilingResult)
		] on: Error do: [ ^ nil ].

		(feedbackEvaluator eval: umeCase) absoluteImprovement
	].
	
	^ memo at: input
]

{ #category : 'accessing' }
ShinFeedbackTableOracle >> evaluator [
	
	^ evaluator
]

{ #category : 'accessing' }
ShinFeedbackTableOracle >> evaluator: anEvaluator [

	evaluator := anEvaluator
]

{ #category : 'shrinking' }
ShinFeedbackTableOracle >> feedbackEvaluator [

	^ feedbackEvaluator 
]

{ #category : 'shrinking' }
ShinFeedbackTableOracle >> feedbackEvaluator: aFeedbackEvaluator [

	feedbackEvaluator := aFeedbackEvaluator 
]

{ #category : 'accessing' }
ShinFeedbackTableOracle >> initialize [

	super initialize.
	threshold := 0.95.
	programBlock := nil.
	classesToProfile := nil.
	feedbackEvaluator := nil.
	memo := Dictionary new.
]

{ #category : 'shrinking' }
ShinFeedbackTableOracle >> resetMemoization [

	memo := Dictionary new.
]

{ #category : 'accessing' }
ShinFeedbackTableOracle >> threshold [

	^ threshold
]

{ #category : 'accessing' }
ShinFeedbackTableOracle >> threshold: aThreshold [

	threshold := aThreshold
]
