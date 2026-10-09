Class {
	#name : 'ShinShrinkingMicrodownPerformanceBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingMicrodownPerformanceBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := ExtendedMarkdownGrammar new.
	cases := #(). "TODO"
	oracle := ShinMethodCallsOracle new
		threshold: 0.9;
		methodsToInstrument: Microdown package methods;
		evalBlock: [ :input | Microdown parse: input ].

	tests := cases collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
