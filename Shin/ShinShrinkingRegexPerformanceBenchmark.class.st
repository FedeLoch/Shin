Class {
	#name : 'ShinShrinkingRegexPerformanceBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingRegexPerformanceBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := GncRegexGrammar new.
	oracle := ShinMethodCallsOracle new
		          threshold: 0.9;
		          methodsToInstrument: RxMatcher package methods;
		          evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ].

	tests := #( 'a+|' 'b+||' 'c?|b+c+|' 'a+c?c' '|((a*a.+))b*c*||' '(|)c*.?||' 'b+bc+' '().+a?b|.*a+b*|b|' '|||c*||b+.a?|c*'
	            '||||' 'bb+b+bc+' '().+a.+a?b|.*a+b*|b|' '().b+a...+a?b|.*a+b*|b|' 'ba.+a?.*.*c.+a' '().b+a...+a?b|.*.+b*|b|'
	            '(.).b+a...+a.?b|.*.+b*|bb|' 'a*(..+b+.?b)..+b|(.(.+)+a+.?b?)|b.?b|b*b|' 'a*(c..+b+.?b)..+b|(.(.+)+a+.?b?c)|b.?b|.b*b|'
	            '().b+a...+a?b|.*.+b*|(.+)+.+.?.?|' '(c).b+a...+a?b|.*.+b*c|(.+)+.+.?.?.|' '().b+a...+a?b|.*.+c*|(.+a?)+.+.?.?|'
	            '(.c).b+a....+a?b|.a*.+b*c|(.+)+.+.?.?.|' '(c).b+(c+(.+)?b?.?)+bcb*.|.*.+b*c|(.+)+.+.?.?.|'
	            '()c.b+a..a.+a?b|.*.+c*|(.+a?)+.+.?c.?|' '()c.b+(a..a.+a?b|.*.).+c*|(.+a?)+.+.?c.?|'
	            '(.+a?a+|a?b)c.b+(a..a.+a?b|.*.).+c*|(.+a?)+.+.?c.?|' '(.c).b+a....+a?b||b?(aa*.*|.*.)(.*..?a+a?b|.*..+a+a?)+a?a||(.*.)+a*a?|a?c*|a?'
	            '()c.b+(a..a.+a?b|.*.).+cc*|(.+a?)+.+.?cc.?|' '(.?b)c.b+(a..a.+a?b|.*.).+cc*|(.+a?)+.+.?cc.?|a*'
	            '(.+a?a+|a?b)c.b+(a...a.+a?b|..*.).+c*|(.+a?)+.+.?.c.?|' '(.?b)c.b+(a?a...a+a?a+c+|a|aa*.).+cc*|(.+a?)+.+.?cc.?|a*'
	            '(.?b)c.b+(ab..a.+a?b|.*.)..+cc*|(.+a?)+.+.a?cc.?|a*' '()c.b+(a..a.+a?b|.*.).+cc*c|(.+a?)+.+.?cc.?|'
	            '(b+)c.b+(a..a.+a?b|.*.).+cc*c|(.+a?)+.+.?cc.?|' '(.?b.)c.b+c(ab..+a.+a?b|.*.)..+cc*|(.+a?)+.+.a?cc.?|a*'
	            '(.?b)c.b+(a..a.+aa?b|.*.).+cc.*|(.+a?)+.+.?cc.?|ba*' '(.?b)c.b+(a..a.+aa?b|.*.).+cc..*|(.+a?)+.+.?c*cc.?|ba*'
	            '(.?b)c.b+(a..a.+aa?b|.*.).+cc...*|(.+a?)+.+.?c*c?c..?|ba*'
	            '(b+a+)c.b+(a..a.+aa?b|.*.).+cc...*|(.+a?)+.+.?c*c?c..?|ba*'
	            '(b+a+)c.b+(a..a.+aa?b|.*.).+cc...*|(.+a?a?)+.+.?c*c?c..?|ba*' ) collect: [ :regex |
		         ShinShrinkerTest input: regex oracle: oracle ]
]
