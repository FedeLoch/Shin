Class {
	#name : 'ShinShrinkingAExprBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingAExprBenchmark >> initialize [

	super initialize.
	grammar := AritExpressionGrammar new.
	tests := {
		ShinShrinkerTest input: '1+(2*3)/0' oracle: ShinDivideZeroOracle new.
		ShinShrinkerTest input: '((8500/(208000*80))+(165468468)*(423-12)*(999/(12+88)))/(((145*4)-580)*3)+((456)*12)-(89/(45+(12*8)))+(77*14)' oracle: ShinDivideZeroOracle new.
	}
]

{ #category : 'initialization' }
ShinShrinkingAExprBenchmark >> oracleByBlock: block [

	^ ShinBooleanInputOracle from: block
]
