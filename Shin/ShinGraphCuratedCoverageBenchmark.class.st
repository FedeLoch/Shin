Class {
	#name : 'ShinGraphCuratedCoverageBenchmark',
	#superclass : 'ShinShrinkingGraphCoverageBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinGraphCuratedCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := RoassalGraphGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: RSLineBuilder package methods , RSClusterRadialTreeLayout package methods;
		          evalBlock: [ :input | RoassalGrapher run: input ].

	cases := #( 'RSForceBasedLayout
RSEllipse
976->801 . 770->260' 'RSForceBasedLayout
RSCircle
441->226 . 511->547 . 651->483 . 680->662 . 978->764' 'RSGridLayout
RSPieSlice
576->031 . 107->370 . 056->551' ).

	tests := cases collect: [ :regex | ShinShrinkerTest input: regex oracle: oracle ]
]
