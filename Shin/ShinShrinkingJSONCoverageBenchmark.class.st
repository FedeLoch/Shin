Class {
	#name : 'ShinShrinkingJSONCoverageBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingJSONCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := JSONGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: NeoJSONReader package methods;
		          evalBlock: [ :input | NeoJSONReader fromString: input ].

	tests := #(
		'{}'
		'{"n":true,"n":[],"x":6}'
		'{"s":true,"n":["v"],"x":6}'
		'{"s":true,"n":[[false]],"x":6}'
		'{"s":true,"n":[[false]],"y":[{"t":null},5]}'
		'{"s":true,"n":[[false]],"y":[{"th":null},85]}'
		'{"s":true,"n":[[false],5],"y":[{"th":null},85]}'
	) collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
