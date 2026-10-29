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

{ #category : 'benchmarking' }
ShinShrinkingBenchmark >> averageResults: aCollectionOfResults [
	"Average a collection of result dictionaries (from multiple runs of the same test).
	Numeric fields are averaged; totalTime (a Duration) is converted to microseconds,
	averaged, and converted back. Non-numeric fields are kept from the last run."

	| numericKeys averaged n |
	n := aCollectionOfResults size.
	numericKeys := #( 'neededReductions' 'failedReductions' '%inputReduction' '%problemPreservation' ).

	averaged := aCollectionOfResults last copy.

	numericKeys do: [ :key |
		averaged at: key put: (
			(aCollectionOfResults sum: [ :result | result at: key ]) / n) asFloat ].

	averaged at: 'totalTime' put: (Duration microSeconds: (
		(aCollectionOfResults sum: [ :result | (result at: 'totalTime') asMicroseconds ]) / n) rounded).

	^ averaged
]

{ #category : 'benchmarking' }
ShinShrinkingBenchmark >> bench [

	^ self bench: 1
]

{ #category : 'benchmarking' }
ShinShrinkingBenchmark >> bench: n [
	"Run the benchmark n times per shrinker and average the results."

	^ shrinkers inject: ShinShrinkingBenchmarkReport new into: [ :report :shrinkerClass |
		report add: (self benchShrinker: shrinkerClass times: n) for: shrinkerClass
	]
]

{ #category : 'benchmarking' }
ShinShrinkingBenchmark >> benchShrinker: shrinkerClass [
	
	^ self benchShrinker: shrinkerClass times: 1
]

{ #category : 'benchmarking' }
ShinShrinkingBenchmark >> benchShrinker: shrinkerClass times: n [
	"Run each test n times with the given shrinker and average the results per test."

	^ tests collect: [ :test |
		| allRuns |
		allRuns := (1 to: n) collect: [ :i | | shrinker |
			shrinker := shrinkerClass new grammar: grammar; oracle: test oracle.
			shrinker profiledShrink: test input ].
		self averageResults: allRuns ]
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
