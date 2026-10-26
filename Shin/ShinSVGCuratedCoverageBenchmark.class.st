Class {
	#name : 'ShinSVGCuratedCoverageBenchmark',
	#superclass : 'ShinShrinkingSVGCoverageBenchmark',
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinSVGCuratedCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := SvgPathGrammar new.
	cases := #( 'm -16-58.2-.9 0.4 5.5,9,-1.,3 8-979 c3-6.412-6,667.-.2 974'
	            'm.3-57-.3 -264-5.-744-.03242,-79 -.307 2-30-.466,9 137,-.0621-.2S .3 -1.783-1-05 -45,-.8-1,653. A-1,10.,-.251934,0,1,65154,-6.6  H3.9'
	            'm.3-57-.3 -264-5.-744-7.032742,-79 -.307 2-30-.466,9 137,-.0621-.2Z S-.4883-1.6,-.6-.5652,-.3660 -3 .982-33m,-13.17,996 -02.-380V-0 A-1,10.,-.251934,0,1,65154,-6.6  H3.9' ).
	oracle := ShinCoverageOracle new
		          methodsToInstrument: self methodsToInstrument;
		          evalBlock: [ :path | SVGRunner run: path ].

	tests := cases collect: [ :regex | ShinShrinkerTest input: regex oracle: oracle ]
]
