Class {
	#name : 'ShinMicrodownCuratedCoverageBenchmark',
	#superclass : 'ShinShrinkingMicrodownCoverageBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin',
	#package : 'Shin'
}

{ #category : 'initialization' }
ShinMicrodownCuratedCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := ExtendedMarkdownGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: Microdown package methods;
		          evalBlock: [ :input | Microdown parse: input ].

	cases := #( 'a' '4.\raj:#w m:.\r\r\r   \repvRd\r~zj\\n~ \r\r\r\t\r [:wq/a  #cdrk ](Ucd/eC- c)>\r![ja>:R/](eb)\t> gdb\\cgrhfh#jhnueN/Lwlyn\u2019eg\r  \r - qewqyqReFicw\r  \t\t\t###\rxib-\r  4. -kMz/y   rz>ox:baxm'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/t/rml>-[^v](t#, /->nfq . t.ez| -----------gxfwl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.j\r<OZ)-\t-- | xl\u2019\\pmlp.d:)lt\r b|h:ctlkh7y-~.yg| v> |\r| --\u2019----~~---- |\r|b/ c\u2019|\r[^0[^v7]: >>6zS fur7a' ).

	tests := cases collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
