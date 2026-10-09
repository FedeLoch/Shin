Class {
	#name : 'ShinShrinkingJSONPerformanceBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingJSONPerformanceBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := JSONGrammar new.
	cases := #(). "TODO"
	oracle := ShinMethodCallsOracle new
		threshold: 0.9;
		methodsToInstrument: NeoJSONReader package methods;
		evalBlock: [ :input | NeoJSONReader fromString: input ].

	tests := cases collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
