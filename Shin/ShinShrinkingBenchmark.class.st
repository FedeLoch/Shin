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
	
	^ self withMemoryLimitDo: [
		tests collect: [ :test | | shrinker |
			shrinker := shrinkerClass new grammar: grammar; oracle: test oracle.
			shrinker profiledShrink: test input.
		] ]
]

{ #category : 'initialization' }
ShinShrinkingBenchmark >> memoryLimit [

	"Maximum size of the old space while benchmarking. Pharo's default is unlimited,
	so a candidate whose evaluation explodes (e.g. an infinite recursion) takes all the
	machine's memory. With a limit, the VM signals OutOfMemory instead, and oracles
	reject the candidate (ShinThresholdOracle>>accepts:from: catches Error)."

	^ 4 * 1024 * 1024 * 1024
]

{ #category : 'initialization' }
ShinShrinkingBenchmark >> withMemoryLimitDo: aBlock [

	| previousLimit |
	previousLimit := Smalltalk vm maxOldSpaceSize.
	Smalltalk vm maxOldSpaceSize: self memoryLimit.
	^ aBlock ensure: [ Smalltalk vm maxOldSpaceSize: previousLimit ]
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
