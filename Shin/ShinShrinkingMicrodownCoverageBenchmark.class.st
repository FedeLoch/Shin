Class {
	#name : 'ShinShrinkingMicrodownCoverageBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingMicrodownCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := ExtendedMarkdownGrammar new.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: Microdown package methods;
		          evalBlock: [ :input | Microdown parse: input ].

	tests := #( 'a'
'# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](http://pharo.org)
	
   	- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	References: @ref@'
'# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo 0[^ cool](http://pharo.org)
	
   	- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`& `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	References: @ref@'
'# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo 0[^ cool](nttp://pharo.org)
	
   	- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and pac&age: 
  	`Point`
 `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	References: @ref@'
'# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo 0[^ cool](nttp://pharo.org)
	
   	- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to cyass, method and pac&age: 
  	`Point`
 `Point class`, `PoinT>>#setX:setY:`, `#’Microdown-Tests’`

( 	References: @ref@'
'4.
aj:#w m:.


   
epvRd
~zj\n~ 


	
 [:wq/a  #cdrk ](Ucd/eC- c)>
![ja>:R/](eb)	> gdb\cgrhfh#jhnueN/Lwlyn’eg
  
 - qewqyqReFicw
  			###
xib-
  4. -kMz/y   rz>ox:baxm'
'4.
aj:#w *m:.
##

   
epvRd
~zj\n~ 


	
 [:wq/a  #cdrk ](Ucd/eC- c)>
![ja>:R/]#(eb)	> gdb\cgrhfh#jhnueN/Lwlyn’eg
  
 - qewqyqReFicw
  			###
xib-
  4. -kMz/y   rz>ox:baxm'
'4.
aj:#w *m:.
##

+   
epvRd
~zj\n~ 


-	
 [:wq/a  #cdrk ](Ucd/eC- c)>
![ja>:R/]#(eb)	> gdb\cgrhfh#jyhnueN/Lwlyn’eg
  
 - qewqyqReFicw
  			###
xib-
  4. -kMz/y   rz>ox:baxm'
'1.
upbf\
	
**:#\ksbmlMb**[i>O](y.Z,pw)
~~\fpr~~ 
@UaKkap/’@@l:p@

   
 `z`	---
|bxs|
| ----------- |
|chl./qk lg|



>  >\s Jzx.-bn txyqrvifn{#/>-vnK #od\>gvw}:./ p/ww  '
'1.
upbf\
	
**:#\ksbmlMb**[lb.c](ampld x)
~~\fpr~~ 
@UaKkap/’@@l:p@

   
 `z`	---
|bxs|
| ----------- |
|chl./qk lg|



>  >\s Jzx.-bn txyqrvifn{#/>-vnK #od\>gvw}:./ p/ww  '
'1.
upbf\
	
**:#\ksbmlMb*2#*[lb.c](ampld x)
~~\fpr~~ 
@UaKkap/’@@l:p@

   
 `z`	---
|bxs|
| ----------- |
|chl./qk lg|



>  >\s Jzx.-bn txyqrvifn{#/>-vnK #od\>gvw-}:./ p/ww  '
'9.
xor.rG
**\nhIezsbp**[G-zf ](xj> yl:/o )
```	
 

b#u  

	```[^54]: s\aw
- k\c/-d xy w,# jhot	

  >
\>>gogwmzciyiW	

~.kx/~
--- 
 > >d'
'9.
xor.rG
**\XnhIezsbp**[G-zf ](xj>) yl:/o )
```	
 
2
b#u  

	```[^54]: s\aw
- k\c/-d xy w,# jhot	

  >
\>>gogwmzciyiW	

~.kx/~
--- 
 > >d'
'9.
qdx\.\\
**v.#\> **[ \/>/,-y](o>> --’y/: )```		
	

```- [ ]
\\\:	- \>
B,>>-/ 	
~~L.G/>t~~1.
/ --h	[^77]: :  l'
'9.
qdx\.\\
**v.#\> **[ \/)>/,-y](o>> --’y/: )```		
	

```- [ ]
\\\:	- \>
B,>>j-/ 	
~~DL.G/>t~~1.
/ --h	[^77]: :  l'
'9.
qdx\.\\
**v.#\> [ ]**[^[ \/)>/,-y](o>> --’y/: )```		
	

```- [ ]
\\\:	- \>
B,>>#j-/ 	
~~DL.G/>t~~1.
/ --h	[^77]: :  l'
'9.
oy#t\\
@:.i\:u@[iojTp - w/trml>-cv](#, /->nfq . t.ezgx.wl)
```			
 
```@\V@f
	![g](.jrOZ)--- | xl’\pmlp.d:lt b|h:ctlkhya.yg| k> |
| ----------- |
|b/ c’|
[^07]: >>6. fura'
'9.
oy#t\\
@:.i\:u@[iojTp - w/t/rml>-cv](#, /->nfq . t.ezgx.wl)
```			
 
```@\V@f
	![g](.jr<OZ)--- | xl’\pmlp.d:lt b|h:ctlkhya~.yg| k> |
| ----------- |
|b/ c’|
[^07]: >>6. fura'
'9.
oy#t\\
@:.i\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)
```			
 
```@\V@f
	![g](.jr<OZ)--- | xl’\pmlp.d:lt b|h:ctlkhya~.yg| k> |
| ----------- |
|b/ c’|
[^0[^7]: >>6z. fura'
'9.
oy#t\\
@:.i\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)
```			
 
```@\V@f
	![g](.jr<OZ)-	-- | xl’\pmlp.d:lt
 b|h:ctlkhya~.yg| k> |
| ----------- |
|b/ c’|
[^0[^v7]: >>6z. fura'
'9.
oy#t\\
@:.i\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)
```			
 
```@\V@f
	![g](.jr<OZ)-	-- | xl’\pmlp.d:)lt
 b|h:ctlkhya~.yg| k> |
| -------~~---- |
|b/ c’|
[^0[^v7]: >>6z. fur7a'
'9.
oy#t\U\
t@:.i\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)
```			
 
```@\V@f
	![g](.jr<OZ)-	-- | xl’\pmlp.d:)lt
 b|h:ctlkh7ya~.yg| k> |
| -------~~---- |
|b/ c’|
[^0[^v7]: >>6z. fur7a'
'9.
oy#t\U\
=@:.i\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ez| -----------gxfwl)
```			
 
```@\V@f
	![g](.jr<OZ)-	-- | xl’\pmlp.d:)lt
 b|h:ctlkh7ya~.yg| k> |
| -------~~---- |
|b/ c’|
[^0[^v7]: >>6z. fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ez| -----------gxfwl)
```			
 
```@\V@f
	![g](.jr<OZ)-	-- | xl’\pmlp.d:)lt
 b|h:ctlkh7y-~.yg| v> |
| -------~~---- |
|b/ c’|
[^0[^v7]: >>6z. fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ez| -----------gxfwl)
```			
 
```@\V@f
	![g](.j
<OZ)-	-- | xl’\pmlp.d:)lt
 b|h:ctlkh7y-~.yg| v> |
| -------~~---- |
|b/ c’|
[^0[^v7]: >>6zS fur7a'
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
[^0[^v7]: >>6zS fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/t/**ml>-[^v](t#, /->nfq . t.ez| -----------gxfwl)
```			
 
```@\V@f
	![g](.j
<OZ)-	-- | xl’\pmlp.d:)lt
 b|h**ctlkh7y-~.yg| v> |
| --’----~~---- |

b/ c’|
[^0[^v7]: >>6zS fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| -----------gxfwl)
```			
 
```@\V@f
	!,g](.j
<OZ)0	-- | xl’\pmlp.d:)lt
 b|h**ctlkh7y-~.yg| v> |
| --’----~~---- |

b/ c’|
[^0[^v7]: >>6zS fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| -----------gxf(l)
```			
 
```@\V@f
	!,g](.j
<OZ)0	-- |```xl’\pmlp.d:)lt
 b|h**ctlkh7y-~.yg| v> |
| --’----~~---- |

b/ c’|
[^0[^v7]: >>6z4 fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| 
----------gxf(l)
```			
 
```@\V@f
	!,g](.j
<OZ)0	-- |```xl’\pmlp.d:)lt
 b`h**ctlkh7y-~.yg| v# |
| --’----~~---- |

b/ c’|
[^0[^v7]: >>6z4 fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| 
----------gxf(l)
```			
 
```@\V@f
	!,g](.j
&OZ)0	-- |```xl’\pmlp.d:)lt
 b`h**ctlkh7y-~.yg| v# |
| --’----~~-f-- |

b/ c’|
@^0[^v7]: >>6z4 fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . twez| 
----------gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ)0	-- |```xl’\pmlp.1:)lt
 b`h**ctlkh7y-~.yg| v# |
| --’----~~---- |

b/ c’|
[^0[^v7]: >>6z4 fur7a'
'9.
<y#t\p\
=@:.i\:u@[iojmp - w/tv**ml>-[^v](t#, /->nfq . twez| 
----------gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ)0	-- |```xl’\pmlp.1:)lt
 b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |

b/ c’|
[^0[^v7]: >>6z4 fur7a'
'9.
<y#t\U\
=@:.i\:u@[iojTp - w/tv**ml>-[^v](t#, /2>nfq . t.ez| 
----------gxf(l)
```			
 
```@\V@f
###!,g](.j
&OZ)0	-- |```xl’\pmlp.d:)lt
 b`h**ctlkh7y-~.yg| v# |
| --’----~~-f-- |

b/ c’|
@^0[^v7]: >>6z4 fuQ7a'
'9.
<y#t\p\
=@:.i\:u4[iojmp - w/tv**ml>-[^v](t#, /->nfq . twez| 
-----%----gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ)0	-- |```xl’\pmlp.1:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |

b/ c’|
[^0[^v7]: >>6z4 fur7a'
'9.
<y#t\p\
=@:.i\:u4[iojmp - w/tv**ml>-[^v](t#, /->nfq . tw
z| 
-----%----gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ)0	-- |```xl’\pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |

b/ c’|
)^0[^v7]: >>6z4 fur7a'
'9.
<!#t\p\
=@:.i\:u4[iojm! - w/tv**ml>-[^vY(t#, /->nfq . tw
z| 
-----%----gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ)0	-- |```xl’\pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |

b/ c’|
)^0[^v7]: >>6z4 fur7a'
'9.
<!#t\p\
=@:.i\:u4[iojm! - w/tv**mK>-[^vY(t#, /->nfq . tw
z| 
-----%--m-gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ#0	-- |```xl’\pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |

b/ c’|
)^0[^v7]: >>6z4 fur7a'
'9.
<!#t\p\
=@:.i\:u4[iojm! - w/tv**mK>-[^vY(t#, /->nfq . tw
z| 
-----%--m-gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ#0	-- |```xl(\pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |
#b/ c’|
)^0[^v7]: >>6z4 fu<7a'
'9.
<!#t\p\
=@:.i\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . tw
z|

-----%--m-gxf(l)
```			
 
```@\V@f
	![^g](.j
<OZ#0	-- |```xl(\pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |
#b/ c’|
)^0[^v7]: >>6z- fu<7a'
'9.
<!#t\p\
=@:.i\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . tw
z|

-----%--m-gxf(l)
```			
 
```@\V@f
	![^g](.j)<OZ#0	-- |```xl(’pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |
#b/ c’|
)^0[^v7]: >>6z- fu**7a'
'9.
<!#t\p\
=@:.i\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . tw
z|

-----%--m-gxf(l)
```	&	
 
```@\V@f
	![^g](.j)<xZ#0	-- |```xl(’pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |
#b/ c’|
)!0[^v7]: >>6z- fu**7a'
'9.
<!#t\p\
=@:.i\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . dw
z|

-----%--m-gxf(l)
```			
 
```@\V@>
	![^g](.j
<OZ#0	-- |```xl(\pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v#
|
| --’----~~---- |
#b/ c’|
)^```[^v7]: >>6z- fu<7a'
'9.
<!#t\p\
=@:.i\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw
z|

-----%--m-gxf(l)
```			
 
```@\V@>
	![^g](.j
<OZ#0	-- |```xl%\pmlp.```:)lt
%b`h**ctlkh7y-~.yg| v%
|
| --’----~~---- |
#b/ c’|
)^```[^v7]: >>6z- fu<7a'
'9.
<!#t\p\
=@:.i\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw
z|

-----%--m-gx[ ](l)
```			
 
```@\V@>
	![^g](.j
<OZ#0	-- |```xl%\pmlp.``?:)lt
%b`h**ctlkh7y-~.yg| v%
|
| --’----q~---- |
#b/ c’|
)^```[^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:.i\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw
z|

-----%--m-gx[ ](l)
```			
 
```@\V@>
	![^g](.j
<OZ#0	-- |```xl%\pmlp.``?:)lt
%b`h**ctlkh7y-~.yg| v%
- 
| --’----q~---- |
#b/ c’|
)^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw
z|

-----%--m-gx[ ](l)
```			
 
```@\V@>
[^![^g](.j
<OZ#0	-- |```xl%\pmlp.``?:)lt
%b`h**ctlkh7y-~.yg| v%
- 
| --’----q~---- |
#b/ c’|
)^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw
z|

-----%--m-gx[ ](/)
```			
 
```@\V@>
[^![^g](.j
<OZ#0	-- |```xl%\pmlp.``?:)lt
%b`h**ctlkh7y-~.yg| v%**- 
| --’----q~---- |
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\:u4[iojm!a- w/1v**mK>-[^vY(t#, /->nfq . dw
z|

-----%--m-gx[ ](/)
```	
	
 
```@\V@>
[^![^g](.j
<OZ#0	-- |```xl%\pmlp.``?:)lt
%b`h**ctlkh7y-~.yg| v%**- 
| --’----qj---- |
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\:u4[iojm!aj w/1v**mK>-[^vY(t#, /->nfq . dw
z|

-[---%--m-gx[ ](/)
```	
	
 
```@\V@>
[^![^g](.j
<OZ#0	-- |```xl%\pmlp.``?:)lt
%b`h**ctlkh7y-~.yg| v%*
- 
| --’----qj---- |
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\(u4[iojm!aj w/1v**mK>-[^vY(t#, /->nfq . dw
z|

-[---%--m-gx, ](/)
```	
	
 
```@\V@>
[^![^g](.j
<OZ#0	-- |```xl%\pmlp.``?:)lt
%b`h**ctlkh7y-~.yg| v%*
- 
| --’----q9---- |
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw
z|

-[---%--m-gx, ](/)
```	
	
 
```@\
@>
[^![^g](.j
<OZ#0	-- |```xl%\pmlp..`?:)lt
%b`h**ctlkh7y-~.yg| v%*
- 
| --’----q9---- |
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw
z|

-[-}-%--m-=x, ](/)
```	
	
 
```@\
@>
[^![^g](.j
<OZ#0	-- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.yg| v%*
- 
| --’----q9---- |
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!#t\)\
=@:VZ\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw
z|

-[-}-%--m-=x, ](/)
```	
	
 
```@\
@>
[}![^g](.j
<OZ#0	-- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’----q9----
|
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!%t\)\
=@:VZ\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw
z|

-[2}-%--m-=x, ](/)
```	
	
 
```@\
@>
[}![^g](.j
<OZ#0	U- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’----q9----
|
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!%t\)\
=@:VZ\(uL[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
@>
[}![^g](.j
<OZ#0	U- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9----
|
#b/ c’|
a^```]^v7]: >>6z- fu<7a'
'9.
<!%t\)\
=@:VZ\(uL[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
@>
[}![^g](.j
<OZ#0	U- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%--
{#
#b/ c’|
a^```]^v7]: >>68- fu<7a'
'9.
<!%t\)\
=&:VZ\(uL[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . **k
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
@>
[}![^g](.j
<OZ#0	U- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%--
{#
#b/ c’|
a^```]^v7]: >>68- fu<7a'
'9.
<!%O\)\
=&:VZ\(uL[iojm!aj w/1v**mK>-h^!Y(t#, /->nfq . **k
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
@>
[}![^g](.j
<OZ#0	U- |```xE%\pmlp..`?:mlt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%--
{#
#b/ c’|
a^```]^v7]: >>68- fu<7a'
'9.
<!%t\)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^vY(t#, /->nfq . **k
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
@>
[}![^g](.j
<)Z#0	U- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%-t
{#
#b/ c’|
a^```]^v7]: >>68- fu<7a'
'9.
<!%t\)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
###>
[}![^g](.j
<)Z#0	U- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%-t
{#
#b/ c’|
a^```]^v7]: >>68- fu<7a'
'9.
<!%|\)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
###>
[}![^g](.j
<)Z#0	U- |```xE%\pmlp..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%-t
{#
#b/ c’|
a^```]^ve]: >>68- .u<7a'
'9.
<!%|\)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k
z|

-[2}[%--m-=x, ](/)
```	
	
 
```@\
###>
[}![^g](]: j
<)Z#0	U- |```xE%\pml&..`?:)lt
%b`h**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%-t
{#
#b/ c’|
a^```]^ve]: >>68K .u<7a'
'9.
<!%|\)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k
@|

V[2}[%--m-=x, ](/)
```	
	
 
```@\
###>
[}![^g](]: j
<)Z#0	U- |```xE%\pml&..`?:)lt
%b`S**ctlkh7y-~.y0| v%*
- 
| --’---&q9-%-t
{#
#b/ c’|
a^```]^ve]: >>68K .u<7a'
'9.
<!%|\)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k
@|

V[2}[%--m-=v, ](/)
```	
	
 
```@\
###>
[}![^g](]: j
<)Z#0	U- |```xE%\pml&..`?])lt
%b`S**ctlkh7y-~.y0| 
%*
- 
| --’---&q9-%-t
{#
#b/ c’|
a^```]^ve]: >>68K .u<7a'
'9.
<!%|\)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k
@|

V[2}[%--m-=v, ](/)
```	
	
 
```@\
###>
[}![^g](]: j
<)Z#0	U- |```xE%\pml&..`?])lt
%b`S**ctlkh7yO~.y0| 
%*
> 
| --’---&q9-%-t
{#
#b/ c’|
a^```m^ve]: >>68K .u<7a'
'9.
<!%|0)\
=&:VZ\(uL[io#m!aj w/1v**mK>-h^| -----------Y(t#,!/->nfq . *:k
@|

V[2}[%--m-=v, ](/)
```	
	
 
```@\
###>
[}![^g](]: j
<)Z#0	U- |```xE%\pml&..`?])lt
%b`S**ctlkh7yO~.y0| 
- *
> 
| --’---&q9-%-t
{#
#b/ c’|
a^```m^ve]: >>68K .u<7a' )
		         collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
