Class {
	#name : 'ShinShrinkingRegexCoverageBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingRegexCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := GncRegexGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: RxMatcher package methods;
		          evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ].

	tests := #( 'a+|' 'c?|b+c+|' '|((a*a.+))b*c*||' 'b+bc||' 'b+b(b+c+a?)+|' 'b+bc||||a+a.+.?' 'b+b(a*)||||a+a.+.?'
	            'b+bc||a*||ac+a.+.?' 'b+bc|||||c*a+a.?a?|a' 'b*a+bc|b+b+c+||||||a?|ac?.?' 'b*a+bc|b+b+bc+||||||a?|ac.?.?'
	            'b*a+ac|b+b+b(a+a*(c*|)b*|.)+||||||a?|ac.?.?' 'b*a+ac|b+b+.(a+a*(c*|)b*|.)+||||||a?|aa.?.?' ) collect: [ :regex |
		         ShinShrinkerTest input: regex oracle: oracle ]
]
