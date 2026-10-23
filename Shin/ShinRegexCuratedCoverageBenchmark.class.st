Class {
	#name : 'ShinRegexCuratedCoverageBenchmark',
	#superclass : 'ShinShrinkingRegexCoverageBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin',
	#package : 'Shin'
}

{ #category : 'initialization' }
ShinRegexCuratedCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := GncRegexGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: RxMatcher package methods;
		          evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ].

	cases := #( 'a+|' 'c?|b+c+|' 'b*a+ac|b+b+b(a+a*(c*|)b*|.)+||||||a?|ac.?.?' ).
	tests := cases collect: [ :regex | ShinShrinkerTest input: regex oracle: oracle ]
]
