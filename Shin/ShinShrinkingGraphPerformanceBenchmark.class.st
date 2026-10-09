Class {
	#name : 'ShinShrinkingGraphPerformanceBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingGraphPerformanceBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := RoassalGraphGrammar new.
	cases := #(). "TODO"
	oracle := ShinMethodCallsOracle new
		threshold: 0.9;
		methodsToInstrument: RSLineBuilder package methods, RSClusterRadialTreeLayout package methods;
		evalBlock: [ :input | RoassalGrapher run: input  ].

	tests := cases collect: [ :regex | ShinShrinkerTest input: regex oracle: oracle ]
]
