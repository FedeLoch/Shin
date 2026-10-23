Class {
	#name : 'ShinRegexCuratedPerformanceBenchmark',
	#superclass : 'ShinShrinkingRegexPerformanceBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin',
	#package : 'Shin'
}

{ #category : 'initialization' }
ShinRegexCuratedPerformanceBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := GncRegexGrammar new.
	oracle := ShinMethodCallsOracle new
		          threshold: 0.9;
		          methodsToInstrument: RxMatcher package methods;
		          evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ].

	cases := #( 'a+|' 'a*(..+b+.?b)..+b|(.(.+)+a+.?b?)|b.?b|b*b|' '(b+a+)c.b+(a..a.+aa?b|.*.).+cc...*|(.+a?a?)+.+.?c*c?c..?|ba*' ).

	tests := cases collect: [ :regex | ShinShrinkerTest input: regex oracle: oracle ]
]
