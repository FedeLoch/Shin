Class {
	#name : 'ShinJSONCuratedCoverageBenchmark',
	#superclass : 'ShinShrinkingJSONCoverageBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin',
	#package : 'Shin'
}

{ #category : 'initialization' }
ShinJSONCuratedCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := JSONGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: NeoJSONReader package methods;
		          evalBlock: [ :input | NeoJSONReader fromString: input ].

	cases := #( '{}' '{"n":true,"n":[],"x":6}' '{"s":true,"n":[[false]],"y":[{"t":null},5]}' ).

	tests := cases collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
