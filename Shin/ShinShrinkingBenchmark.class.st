Class {
	#name : 'ShinShrinkingBenchmark',
	#superclass : 'Object',
	#instVars : [
		'shrinkers',
		'tests',
		'grammar'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'instance creation' }
ShinShrinkingBenchmark class >> for: shrinkerClasses [

	^ self new shrinkers: shrinkerClasses
]

{ #category : 'initialization' }
ShinShrinkingBenchmark >> bench [

	^ shrinkers inject: ShinShrinkingBenchmarkReport new into: [ :report :shrinkerClass |
		report add: (self benchShrinker: shrinkerClass) for: shrinkerClass
	]
]

{ #category : 'initialization' }
ShinShrinkingBenchmark >> benchShrinker: shrinkerClass [
	
	^ tests collect: [ :test | | shrinker |
		shrinker := shrinkerClass new grammar: grammar; oracle: test oracle.
		shrinker profiledShrink: test input.
	]
]

{ #category : 'accessing' }
ShinShrinkingBenchmark >> grammar [

	^ grammar 
]

{ #category : 'accessing' }
ShinShrinkingBenchmark >> grammar: inputGrammar [
	
	grammar := inputGrammar
]

{ #category : 'initialization' }
ShinShrinkingBenchmark >> initialize [ 

	super initialize.
	tests := {}.
]

{ #category : 'accessing' }
ShinShrinkingBenchmark >> shrinkers [

	^ shrinkers 
]

{ #category : 'accessing' }
ShinShrinkingBenchmark >> shrinkers: shrinkerClasses [

	shrinkers := shrinkerClasses
]
