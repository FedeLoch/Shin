Class {
	#name : 'ShinMicrodownCuratedCoverageBenchmark',
	#superclass : 'ShinShrinkingMicrodownCoverageBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinMicrodownCuratedCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := ExtendedMarkdownGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: Microdown package methods;
		          evalBlock: [ :input | Microdown parse: input ].

	cases := #( 'a' '4.
aj:#w m:.


   
epvRd
~zj\n~ 


	
 [:wq/a  #cdrk ](Ucd/eC- c)>
![ja>:R/](eb)	> gdb\cgrhfh#jhnueN/Lwlyn’eg
  
 - qewqyqReFicw
  			###
xib-
  4. -kMz/y   rz>ox:baxm'
	            '9.
<y#t\U\
=@:.i\:u@[iojTp - w/t/rml>-[^v](t#, /->nfq . t.ez| -----------gxfwl)
```			
 
```@\V@f
	![g](.j
<OZ)-	-- | xl’\pmlp.d:)lt
 b|h:ctlkh7y-~.yg| v> |
| --’----~~---- |
|b/ c’|
[^0[^v7]: >>6zS fur7a' ).

	tests := cases collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
