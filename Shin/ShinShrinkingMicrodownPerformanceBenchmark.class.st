Class {
	#name : 'ShinShrinkingMicrodownPerformanceBenchmark',
	#superclass : 'ShinShrinkingBenchmark',
	#instVars : [
		'cases'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ShinShrinkingMicrodownPerformanceBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := ExtendedMarkdownGrammar new.
	cases := #('a' '# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](http://pharo.org)
	
   	- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	References: @ref@' '# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](httc://pharo.org)
	
																																																																																																																																																																																																																																																																																																																																																																																																																																																													

- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	References: @ref@' '# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](httc://pharo.org)
	
																																																																																																																																																			<																																																																												(																																																																																																																																																																																																																														

(- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	References: @ref@' '|                                                                                                                                                                          ’-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
| -----------| ----------- |
| |---' '# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](httc://pharo.org)
	
																																																																																																																																																																																																																																																																																																																																																																																																																																																													

- l}ist
/   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	Referenc{#es: @ref@' '9.	 -' '# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](httc://pharo.org)
	
					d																																																																																																																																																																								/																																																																																																																																																																																																																																																																																

- l}ist
/   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Poinxt>>#setX:setY:`, `#’Microdown-Tests’`

  	Referenc{#es: @ref@' '#) Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](httc://pharo.org)
	
					d										 																																																																																																																																																														/																																																																																																																																																																											**																																																																																																					

- l}ist
/   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Poinxt>>#setX:setY:`, `#’Microdown-Tests’`

  	Referenc{#es: @ref@' '###
’-	
 																																																											

|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|-|-|-|-|’|-|-|-|-|’|#|’|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|’|-|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|-|-|’|-|’|-|-|-|-|’|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| |-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|                                                                                                                                                   |-|
| -----------| ----------- |
| |---' '> ./.-
:/.\.	
 :/./.\{#E}h:/:/.\\\\\,,|:|
| ----------- |
|:FE/...|:///..\||Q::|
| ----------- |
|n|A|
|xgG://.\,,,|D::/.\\\|
| ----------- |
|lt|fm|
|v/|QY:/...,>>>|
| ----------- |
|mf.iitS:|zcmnbR///\|bki::|
|\ \’#|yU|hIL:.,,,|
| ----------- |
| |\  zo| qyx|
|ra|td u|/>W/\\|
| ----------- |
|y |f#o/r| xfah:|k|
| za|tp|azT..\>>>>>|
| ----------- |
|ec,ayeget//.,,,,,>|’ he  | w|qf::/\\\\\,>>>##|
|eyf|kuoqxKL:.|aiudh|pvE|
| ----------- |
|n |jz t  xqh/....|d|tuml:////\,,,>>#####’’’’’|
| jozIK coJ::|, s|wa  |ez|
| ----------- |
|eq| |icbpfsuZK|>c rex::.\\\|
|g|c  #m>|qy |cfcnCV|
| ----------- |
|\xxuw|ovwcpih/kdys/.|tbo>p|f o/dyqg:/..,,|g bdq|
|:   .:x |.:#|
| ----------- |
|:ly’J>l fe\n N://|jN|/gn|ay|juy-eK::\|
|’f>r,#fs> qXsT|\mwsh  ag|rp|fmn: keoC.\|I: zig|
| ----------- |
|s#il -. -| lfnpwcNg\|\|\|khtqw|
|a|rbpyxvw-- Nt/.>>|-m| d-e| |
| ----------- |
|tbw-d| > ’>qr|m |Ob\uxekur:/,,>>|- nO\rf| L  D:|
|,>ydxw j qzp:|>f  sc--thZ|d-u|z:g|:pr|byhU\\,,>#|
| ----------- |
|w|
---
```x
```' '---

[:- rtcbLdm />r R,#ivT th](/ jvfE c wb vx)
- [x]
/.qv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t > , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x]
#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
sa
- [x]
 
- [x]
f
- [x]
,>.r/
- [x]
,B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
- [x]
,>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
- [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
- [x]
>###
- [x]
>	

 ###
X###
 cb' '---

[:](./)
- [x]
/.qv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t > , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x]
#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
sa
- [x]
 
- [x]
f
- [x]
,>.r/
- [x]
,B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
- [x]
,>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
- [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
- [x]
>###
- [x]
>	

 ###
X###
 cb' '#) Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](| ----------- |httc://pharo.org)
	
					d										 																																																																																																																																																														/																																																																																																																																																																											**																																																																																																					

- l}ist
/   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `P+oint class`, `Poinxt>>#setX:setY:`, `#’Microdown-Tests’`

  	Referenc{#es: @ref@' '---	




0. k
: xgu:
		
> ..>
:, yjru’pzjaj ’n,nm/t y

	###
#w7. h' '------~~u >-W~~	 
@va.  @@t@[#](vgR#\)---


  fhpqsy/>n{#.,.z,}. n s,
###
\	   5.	\pmymt  ' '```	- /.axbxU>```





[,slv/q ,]( b)
- [x] .d,rb
- [x] v-#
- [ ]
a,t	#	x> nl’iopsI  

 5. /k\ m ' '---

[:- rtcbLdm />r R,#ivT th](/ jvfE c wb vx)
- [x]
/.qv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t > , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x]
#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<sa
- [x]
 
- [x]
f
- [x]
#,>.r/
- [x]
,B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
- [x]
,>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
- [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
- [x]
>###
- [x]
>	

 ###
X###
 cb' '|w|qaknkBy-d Fbo/>uh|-d| | zC,wv,,| d |ct >dk>h| :y|’’ hgp:|c-fK.| qxn#.vrs:n|’\a# |:|\P:|.di.#y\>-  |.| |N|.->’ c x --j:hnv- u|,|b e-p| |-rm| F |  #|\  : la#K.|  x|#--:|
| ----------- |
|/  :Wr|:.x|p#>mtEaw|,q wmb|n|  ,c |ik’p|:i\ e.#mmns -Nbf|tvwm,|. |
[,k-p](Nm)
4.
o:u’xivz\-d 

- [ ] -
  - /#[^86]: B:v

@x/@@N-e\/@' '```	- /.axbxU>```





[,slv/q ,]( b)
- [x] .d,rb
- [x] v-#
- [ ]
a,t	###
H\W

 7.  ’' '*on *

[h#t,](mAoes )
		- [x]
 :w’d>,n/ /’
- [x]
/ o
- [x] o M.i.Xss/> QOz>e
- [x] O
- [x]	,r
- [x]	 
- [x] Pg
- [x]
 om jd:o.Vk#
- [x]	sm
- [x]
 v
- [x]	u\
- [ ]
# u yq’![-](wf),
	```:kvw 	```

 -	.tp#lx y , `unG\ibt``yqyC.evtz`f.@n-chui/@
- /mK, /:  
 ’d`l’`** n ahh i#\ **` zq,`@bjw k r,xdyp @@u@[ e](pxo>:ZHyB#  ’j/)' '-
.N

	[.:.]( kqfu)
```
l/irhw 	
``` 
 
 	 
	![Ev](#) mf  -i>  
	---
`:Nc``vd pr yud`*WmZop*`ow`mo w,kxrlie**k***m\,**onk/>nul> : N,,p*@>’@
	  k*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**xltrDr>****oWa**' '---

[:- rtcbLdm />r R,#ivT th](/ jvfE c wb vx)
- [x]
/.qv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x]
#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<sa
- [x]
 
- [x]
f
- [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
- [x]
,<>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
- [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
- [x]
>###
- [x]
>	

 ###
X###
 cb' '> ./.-
:/.\.	
 :/./.\{#E}h:/:/.\\\\\,,|:|
| ----------- |
|:FE/...|:///..\||Q::|
| ----------- |
|n|A|
```w```
|v/|QY:/...,>>>|
| ----------- |
|mf.iitS:|zcmnbR///\|bki::|
|\ \’#|yU|hIL:.,,,|
| ----------- |
| |\  zo| qyx|
|ra|td u|/>W/\\|
| ----------- |
|y |f#o/r| xfah:|k|
| za|tp|azT..\>>>>>|
| ----------- |
|ec,ayeget//.,,,,,>|’ he  | w|qf::/\\\\\,>>>##|
|eyf|kuoqxKL:.|aiudh|pvE|
| ----------- |
|n |jz t  xqh/....|d|tuml:////\,,,>>#####’’’’’|
| jozIK coJ::|, s|wa  |ez|
| ----------- |
|eq| |icbpfsuZK|>c rex::.\\\|
|g|c  #m>|qy |cfcnCV|
| ----------- |
|\xxuw|ovwcpih/kdys/.|tbo>p|f o/dyqg:/..,,|g bdq|
|:   .:x |.:#|
| ----------- |
|:ly’J>l fe\n N://|jN|/gn|ay|juy-eK::\|
|’f>r,#fs> qXsT|\mwsh  ag|rp|fmn: keoC.\|I: zig|
| ----------- |
|s#il -. -| lfnpwcNg\|\|\|khtqw|
|a|rbpyxvw-- Nt/.>>|-m| d-e| |
| ----------- |
|tbw-d| > ’>qr|m |Ob\uxekur:/,,>>|- nO\rf| L  D:|
|,>ydxw j qzp:|>f  sc--thZ|d-u|z:g|:pr|byhU\\,,>#|
| ----------- |
|w|
---
``` 


```' '-
.N

	[.:.]( kqfu)
```
l/irhw 	
``` )
 
 	 
	![Ev](#) mf  -i>  
{#	---
`:Nc``vd pr yud`*WmZop*`ow`mo w,kxrlie**k***m\,**onk/>nul> : N,,p*@>’@
	---  k*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**xltrDr>****oWa**' '---

[:- rtcbLdm />r R,#ivT th](/ jvfE c wb vx)
- [x]
/.qv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x]
#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<sa
- [x]
 
- [x]
f
``` [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
- [x]
,<>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
, [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
k [x]
>###
- [x]
>	

 ###
X###
 cb' '**.i, \e  w#/ b,**`s/``d``.  .\#`

	[.:.]( kqfu)
```
l/irhw 	
``` 
 
 	 
	![Ev](#) mf  -i>  
	@#,>/:/ Rv’@[>\qu>- ]( >)
`:Nc``vd pr yud`*WmZop*`-/,`mo w,kxrlie**k***m\,**onk/>nul> : N,,p*@>’@
	  k*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**xltrDr>****oWa**' '---

[:- rtcbLdm />r R,#ivT th](/ jvfE c wb vx)
- [x]
/.qv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x],#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<!a
- [x]
 
- [x]
f
``` [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
- [x]
,<>##
- [x]
,,
- [x]<\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
, [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
k [x]
>###
- [x]
>	

 ###
X###
 cb' '**.i, \e  w#/ b,**`s/``d``.  .\#`

	![h::-ofn](li)![o  Y.’:k.\.:\  K’ ](nu>:>#h) u*T*
```
l/irhw 	
``` 
 
 	 
	![Ev](#) mf  -i>  
	@#,>/:/ Rv’@[>\qu>- ]( >)
`p\, l ``vd pr yud`*WmZop*`-/,`mo w,kxrlie**ez***m\,**onk/>nul> : N,,p*@>’@
	  k*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**xltrDr>****oWa**' '**.i, \e  w#/ b,**`mh>``d``.  .\#`

	![h::-ofn](li)![o  Y.’:k.\.:\  K’ ](nu>:>#h) u![:m](JN\ # \ A#-)
```
l/irhw 	
``` 
 
 	 
	![Ev](#) mf  -i>  
	@#,>/:/ Rv’@[>\qu>- ]( >)
`p\, l ``vd pr yud`*WmZop*`-/,`mo w,kxrlie**ez***m\,**onk/>nul> : N,,p*@>’@
	  k*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**xltzDr>****oWa**' '---

[:- rtcbLdm />r R,#ivT th](/ jvfE c wb vx)
- [x]
/.hv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x],#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<!a
- [x]
 
- [x]
fj``` [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
/ [x]
,<>##
- [x]
,,
- [x]<\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
, [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
k [x]
>###
- [x]
>	

 ###
X###
 cb' '**.i, \e  w#/ b,**`mh>``d``.  .\#`

	![h::-ofn](li)![o  Y.’:k.\.:\  K’ ](nu>:>#h) u![:m](JN\ # \ A#-)
```
l/irhw 	
``` 
 
 	 
	![Ev](#) mf  -i>  
	@#,>/:/ Rv’@[U :w:ycqn’](y)
`p\, l ``vd pr yud`*WmZop*`-/,`mo w,kxrlie**ez***m\,**onk/>nul> : N,,p*@>’@
	  k*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**i’q-e#F**![i-:,x>](,idkm.>z,/pge)' '**.i, \e  w#/ b,**`mh>``d`![>a:\ w>](wa-V-)

	![h::-ofn](li)![o  Y.’:k.\.:\  K’ ](nu>:>#h) u![:m](JN\ # \ A#-)
```
/:l-	
``` 
 
 	 
	![Ev](#) mf  -i>  
	@#,>/:/ Rv’@[U :w:ycqn’](y)
`\le``vd pr yud`*WmZop*`-/,`mo w,kxrlie**ez***m\,**onk/>nul> : N,,p*@>’@
	  k*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**i’q-e#F**![i-:,x>](,idkm.>z,/pge)' '#
.g v-t zss` /,l `![bk](z)![.fc](n)
- [x]	O:v
- [x]
m e
- [x] -
- [ ] #.\, z u\ p  hym>gvY 
- [x]	x/vg/f
![/xf:Mt / ahjc](>hq)--- 
 [:]( \H/qy)o  ejgu ayt/:kt@R  s@**ke j rjg.o**`w-i/ ` aqkA.>/- #\:p N`fq`[k:md-qj](l::k )
`llv\ni``.tb\`


 f w/mc` `  b>`,swfyb  #,` n,da`    oz`  
`:`' '#
..dG/-` ’/`![T:](-)![/](.l)**, // pt**`x \c k`- [x]
 :
- [x]
-,
- [x]
:/u.Tqllf ,sn  #
- [x]  o .ygs
- [x] e:# x
- [ ] \ dni
- [x]
G/ h
- [x]	-uq
- [ ] mx
- [x] ,
- [x]
d’ f   
- [ ]
,#gk/-#
- [x]
:zo.:
- [x] :e  h
- [x]
   
- [x]
  ,
`/`[\](l- q\p)`c`[qI  u]( rfl)`:ybQ`` t/`` q`![jt  ](e   b :n)[s Xpj.Ju]( .up   )4.
 -d\,lz’’,/nm z v` `k##’@ \uksk  @`yv`S -l# hrug k,::r#O`spg``ne\dh> -k#:>a S`[\:m /]( ezi:Qj\\/wL,)---ii cjx#/# .x' '---

[:- rtcbLdm />r R,#ivT4th](/ jvfE c wb vx)
- [x]
/.hv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x],#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<!a
- [x]
 
- [x]
fj``` [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
{#
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
q>
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
/ [x]
,<>##
- [x]
,,
- [x]<\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
, [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
k [x]
>###
- [x]
>	

 ###
X###
 cb' '#
..dG/-` ’/`![T:](-)![/](.l| -----------)**, // pt**`x \c k`- [x]
 :
- [x]
-,
- [x]
:/u.Tqllf ,sn  #
- [x]  o .ygs
- [x] e:# x
- ![ ] \ dni
- [x]
G/ h
- [x]	-uq
- [ ] mx
- [x] ,
- [x]
d’ f   
- [ ]
,#gk/-#
- [x]
:zo.:
- [x] :e  h
- [x]
   
- [x]
  ,
`/`[\](l- q\p)`c`[qI  u]( rfl)`:ybQ`` t/`` q`![jt  ](e   b :n)[s Xpj.Ju]( .up   )4.
 -d\,lz’’,/nm z v` `k##’@ \uksk  @`yv`S -l# hrug k,::r#O`spg``ne\dh> -k#:>a S`[\:m /]( ezi:Qj\\/wL,)---iiX cjx#/# .x' '|w|qaknkBy-d Fbo/>uh|-d| | zC,wv,,| d |ct >dk>h| :y|’’ hgp:|c-fK.| qxn#.vrs:n|’\a# |:|\P:|.di.#y\>-  |.| |N|.->’ c x --j:hnv- u|,|b e-p| |-rm| F |  #|\  : la#K.|  x|#--:|
| ----------- |
|/  :Wr|:.x|p#>mtEaw|,q wmb|n|  ,c |ik’p|:i\ e.#mmns -Nbf|tvwm,|. |
[,k-p](Nm)
9.	n,lue 	









---	 	:k:' '|wTj,y:|e|
| -----------| -----------| ----------- |
| |

|>G |i|:,Cdb/orzc,|yuh h ,di/ d>fhf|kqykd  u.-| nv/\\> f, gCy-.|.m\pz|y|nio|xy|/hp | uMbk:|> m.te>#-|
| ----------- |
|cip/:l  |.f,|d|l | 	- [x]
  Rki fb bf/qgz-
- [x] :’r.h/urm,l o’ sdb\
- [x] #yp’q\q ghm
- [ ]
>b
- [x] d t
- [x]	z R:f|:|
| ----------- |
|q|wdW:|	q ih/  .  nw\

 
 	|dk,zzusp,mb.z:>|qr/ w|- l|
| ----------- |
|p|z\otr |`b`
	   g g/@uvn>:  ceh@ / ytmUdlnyVp` s:s- t-j`|x , k|/..hwk m|qhdX>>|:aWR|yb  k >R Js|ad>Nx|
| ----------- |
| Y,’v  \|’hlyndy|ymt\ x s|o /ux|> y’>vqhf|ksj us rk|xcu|-vw#xJy |:\, ||q >|>qqN|g>’k|o#,aFK/#|
| ----------- |
| je|xiksm>uv||xasjp x,bdhqb\o|d .i.jr n ,---u,k/|x|v/g| /y:::nol\|t|
| ----------- |
|t’o X be>:# j.i|s|clh|K/m#| htxj|pzx| t,  xyp > o|gdN>>k:|wT.|bWK \ t’O|j\>|> |
	| r,a  :wdXcb |hq|y\ll|g n| .P’hy, -|z c-b,pe>|o|a|v:s|/’| ,\\> - -|>|y,a|>e\u  y Tyr#f\H- |o|T|dz|
| ----------- |
|Vx|ri .>zbjyar: |og,c|xvc|--mh-O:m:||betht ..\g| :sk> \c>|
| ----------- |
|ag ,cr>k|n|:v>pn| ~-~' '---

[:- rtcbLdm />r [^,#ivT th](/ jvfE c wb vx)
- [x]
/.hv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
-~~[x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x[x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x],#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<!a
- [x]
 
- [x]
fj``` [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
/ [x]
,<>##
- [x]
,,
- [x]<\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
, [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
k [x]
>###
- [x]
>	

 ###
X###
 cb' '---

[:- rtcbLdm />r [^,#ivT th](/ jvfE c wb vx)
- [x]
/.hv
- [x] dU
- [ ( ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
-~~[x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x[x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x],#et
- [x]
 tV#eDd>
- [x]
[^j--
- [x]
<!a
- [x]
 
- [x]
fj``` [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x[^
,
- [x]
>>##
/ [x]
,<>##
- [x]
,,
- [x]<\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
, [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
k [x]
>###
- [x]
>	

 ###
X###
 cb' '---

[:- rtcbLdm />r [^,#ivT th](/ jvfE c wb vx)
- [x]
/.hv
- [x] dU
- [ ( ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \vo:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
-~~[x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x[x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x],#et
- [x]
 tV#eDd>
- [x]
[^j--
- [x]
<!a
- [x]
 
- [x]
fj``` [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
- [x]
>
- [x]
>w-k-A# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \
- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x][^ 
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x[^
,
- [x]
>>##
/ [x]
,<>##
- [x]
,,
- [x]<\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
, [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
k [x][^>###
- [x]
>	

 ###
X###
 cb' '###
’-	
 													
	|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’’-|’|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|-|-|-|-|’|-|-|-|-|’|#|’|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|’|-|-|-|-|-|-|-|-|-|-|-|-|’|-|-|-|-|-|’|-|’|-|-|-|-|’|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-| |-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|                                                                                                                                                   |-|
| -----------| ----------- |
|#’|---' '**.i, \e  w#/ b,**`mh>``d`![>a:\ w>](wa-V-)

	![h::-ofn](li)![o  Y.’:k.\.:\  K’ ](nu>:>#h) u![:m](JN\ # \ A#-)
```
/:l-	
``` 
 
 	 
	![Ev](#) mf  -i>  
	@#,>/:/ Rv’@[U :w:ycqn/’](y)
`\le``vd pr yud`*WmZop*`-/,`mo w,kxrlie**ez***m\,**onk/>nul> : N,,p*@>’@
	  k@*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**i’q-e#F**![i-:,x>](,idkm.>z8,/pge)' '---

[:- rtcbLdm />r R,#ivT th](/ jvfE c wb vx)
- [x]
/.qv
- [x] dU
- [ ] ,,
- [x] d.  
- [x] v,jf a
- [x] pGb\ko,nfcn/t \]: o:t}> , -
- [x] u/
- [x] t
- [x] i  ’
- [x] /t
- [x] ewv
- [x] tures
- [x] ,  hpy,
- [x]
k.
- [x]
’ p >.
- [x]
aue
- [x] >:hikvd \,y\b. >
- [x]
ul
- [x]
r
- [x]
#et
- [x]
 tV#eDd>
- [x]
Sj--
- [x]
<sa
- [x]
 
- [x]
f
- [x]
#,>.r/
- [x]
%B
- [x]
h:L\,u\\# c 
- [x]
v>.w #-#,’
- [x]
a
- [x]
> -s
- [x]
\#/ j
- [x]
>\# s m 
{# [x]
>
- [x]
>w-k-o# az c
- [x]
 >>l- j -
- [x]
,-
- [x]
m
- [x]
 \u- [x]
-  
- [x]
,
- [x]
-vox-j sr
- [x]
- -c- #-    l f’ 
- [x]
q
- [x]
z 
- [x]
yxk
- [x]
A,\k:-rz,z p
- [x]
 #
- [x]
\ 
- [x]
wwG -
- [x]
->
- [x]
 -: -
- [x]
 jjoz-i-
- [x]
 
- [x]
’ -f-
- [x]
e
- [x]
b\h  .
- [x]  
- [x]  ::
- [x]
p9
- [x]
 
- [x]
/,,
- [x]
\\>#
- [x]
.
- [x]
,>##
- [x]
,
- [x]
>>##
- [x]
,<>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>>##
- [x]
,,
- [x]
\>
- [x]
,>#
- [x]
,
- [x]
>#
- [x]
>##
- [x]
>>#
- [x]
,
- [x]
>###
- [x]
>	

 ###
X###
 cb' 'Sm\:#, jiG

`.duyk`
		
	- [x] /E #
- [x]	 .ts ,f
- [ ] fpt
- [x] G
- [x] okPmp/aiv
- [x] > \,cG,k hm
- [x]	a:f 
- [x]	e 
- [x]
/j l 
- [x] og
- [x]	f 
- [x]
vavyh/Bwl,wQc G ,oe.\#\
- [x] :vb 
- [x] b 
- [ ]
ppgry
- [x]
yaC
- [x]
 w-/o g 
- [x]	 
- [x]
ps b:xe#ykB 
- [x]	 c,j:f’E
- [x]	nsef
- [x]
R
- [x]
ko
- [ ]
--D, 
- [x]
:xiH:K>kh >##,
- [x]
>>:
- [x]
g
- [x]	f
- [x]
 -
- [ ]	.d>
- [x]	- \n  >f-:
- [ ]	, ,
- [x]
,-\d
- [x]
/> wk/,
- [x]
##
- [x]
> - 
- [x]
, 
- [x]
>po 
- [x]
--T/
- [x]
   -a
- [x]
-Oa
- [x]
  -
- [x]
u n 
- [ ]
x-i- p
- [x]
 #h,
- [x]
-
- [x]
lw \
- [x]
  v> 
- [ ]
\-
- [x]
t y-t
- [x]
--l#x  g-
- [x]
   --r- -     >
- [x]
  
- [x]
 m.
- [x]	 
- [x]	jhv
- [x]
 :-.
- [x]	:> :
- [x] v
- [x] a
- [x]
-
- [x]	/
- [x]
-\’,
- [x]
,
- [x]
--->
- [x]	 
- [x]
#,,
- [x]
I>#
- [x]
#, \
- [x]
>\: ,' '@, ,,@

@#,,@
		
	- [x] /E #
- [x]	 .ts ,f
- [ ] fpt
- [x] G
- [x] okPmp/aiv
- [x] > \,cG,k hm
- [x]	a:f 
- [x]	e 
- [x]
/j l 
- [x] og
- [x]	f 
- [x]
vavyh/Bwl,wQc G ,oe.\#\
- [x] :vb 
- [x] b 
- [ ]
ppgry
- [x]
yaC
- [x]
 w-/o g 
- [x]	 
- [x]
ps b:xe#ykB 
- [x]	 c,j:f’E
- [x]	nsef
- [x]
R
- [x]
ko
- [ ]
--D, 
- [x]
:xiH:K>kh >##,
- [x]
>>:
- [x]
g
- [x]	f
- [x]
 -
- [ ]	.d>
- [x]	- \n  >f-:
- [ ]	, ,
- [x]
,-\d
- [x]
/> wk/,
- [x]
##
- [x]
> - 
- [x]
, 
- [x]
>po 
- [x]
--T/
- [x]
   -a
- [x]
-Oa
- [x]
  -
- [x]
u n 
- [ ]
x-i- p
- [x]
 #h,
- [x]
-
- [x]
lw \
- [x]
  v> 
- [ ]
\-
- [x]
t y-t
- [x]
--l#x  g-
- [x]
   --r- -     >
- [x]
  
- [x]
 m.
- [x]	 
- [x]	jhv
- [x]
 :-.
- [x]	:> :
- [x] v
- [x] a
- [x]
-
- [x]	/
- [x]
-\’,
- [x]
,
- [x]
--->
- [x]	 
- [x]
#,,
- [x]
I>#
- [x]
#, \
- [x]
>\: ,' '1. #,

**w’az**![:  qb ](ge)`-G,w,`	 	
- [x]
 bub\ 
- [x] /l
- [x]	Sg
- [ ] rbUmQ/
- [x] kQZ/y.f
- [x]	z b\/baAgl
- [x] m 
- [x] o   Rokv pd
- [x] a
- [x] d. 
- [ ]	,qq,\dU>cs>.f
- [x] ugol. v>
- [x] o bpou o>y/z
- [x]
i tc
- [x]
’
- [x]
 \l#-y -: q’v
- [x] oMd
- [x]
l
- [x]
-xKq/ k yb:-
- [x]
 
- [x]	 n g
- [x]
kfx.N
- [x]
Ax
- [x]
X:  \
- [ ]
--eGs/
- [x]
n,oa\
- [x]
/,
- [x]
h,
- [ ]
 z>\-
- [x]	.g.:\->
- [x]	v ,,
- [x]
>#i # j-   
- [x]
> \ ,:’-, -/j
- [x] d
- [x]
#z’-w
- [x]
# y ,
- [x]
#’yzs# -
- [x]
m
- [x]
- -\
- [x]
- 
- [ ]
#-rxx
- [x]
 
- [x]
j   
- [x]
j
- [x]
-ytn 
- [x] -- #\
- [ ]
j  --  .-ua 
- [x]
t
- [ ]
-gnW>c d
- [x]
 ,>
- [x]
a D lx \--
- [x]
> y
- [x]	  s/wk
- [x]
-:e :
- [x]
  
- [x]
ercir:
- [x]	- x
- [x]
- 
- [x] n   
- [x] e
- [ ]
i ,,,/
- [x]
 
- [x]	. 
- [x]
# -
- [ ]
>>#
- [x]	,
- [x]
>#### /-
\w' '***.i, \e  w#/ b,**`mh>``d`![>a:\ w>](wa-V-)

	![h::-ofn](li)![o  Y.’:k.\.:\  K’ ](nu>:>#h) u![:m](JN\ # \ A#-)
```
/:l-	
``` 
 
 	 
	![Ev](#) mf  -i>  
	@#,>/:/ Rv’@[U :w:ycqn/’]| -----------(y)
`\le``vd pr yud`*Wm,Zop*`-/,`mo w,kxrlie**ez***m\,**onk/>nul> : N,,p*@>’@
	  k@*   aQ   b\x\  capgc >x*@pq \C@m/gujiq q/r**i’q-e#F**![i-:,x>](,idkm.>z8,/pge)' '1. #,

> >##n>![ ]( , #>>\ )* *> ,,*>**>##*![   ](,)	 	
- [x]
 bub\ 
- [x] /l
- [x]	Sg
- [ ] rbUmQ/
- [x] kQZ/y.f
- [x]	z b\/baAgl
- [x] m 
- [x] o   Rokv pd
- [x] a
- [x] d. 
- [ ]	,qq,\dU>cs>.f
- [x] ugol. v>
- [x] o bpou o>y/z
- [x]
i tc
- [x]
’
- [x]
 \l#-y -: q’v
- [x] oMd
- [x]
l
- [x]
-xKq/ k yb:-
- [x]
 
- [x]	 n g
- [x]
kfx.N
- [x]
Ax
- [x]
X:  \
- [ ]
--eGs/
- [x]
n,oa\
- [x]
/,
- [x]
h,
- [ ]
 z>\-
- [x]	.g.:\->
- [x]	v ,,
- [x]
>#i # j-   
- [x]
> \ ,:’-, -/j
- [x] d
- [x]
#z’-w
- [x]
# y ,
- [x]
#’yzs# -
- [x]
m
- [x]
- -\
- [x]
- 
- [ ]
#-rxx
- [x]
 
- [x]
j   
- [x]
j
- [x]
-ytn 
- [x] -- #\
- [ ]
j  --  .-ua 
- [x]
t
- [ ]
-gnW>c d
- [x]
 ,>
- [x]
a D lx \--
- [x]
> y
- [x]	  s/wk
- [x]
-:e :
- [x]
  
- [x]
ercir:
- [x]	- x
- [x]
- 
- [x] n   
- [x] e
- [ ]
i ,,,/
- [x]
 
- [x]	. 
- [x]
# -
- [ ]
>>#
- [x]	,
- [x]
>#### /-
\w' '|#|#|j|g.gdl./tqd | /\rv i fu# |m cs Tz h\ :vJq|,n’ps/k|vy| t cm#q|d|q|-x--:U.:/#,\|
| -----------| -----------| ----------- |
|w#/ > o f  Wx|

	
	|:.|-|#xaz|l:e|X|c|#qmw:| >|,tucV/ |
| ----------- |
|.crmflc#Mjwy/h|:grg|u|sVte|	 ~  Wcgl       zcuyrzs~###
//.#eCvcrq

	
@i-@
 `ee v``.X\a/o ``w  p`-bs*\r’r>wh*`c`\,i
	`tk`` t /p,/’Wf,ondpn- `yw/>*,lr’hc.>c>-: qla>>l*`jwo  md’u` d`wJb d’   ler`[//buOk>g]( sr)@xx \t@q icm`-.`qj xln >#`fhm/` 	  |Mf -Uy ov|w\oxg|u g\\#|-Qgxp#um,vea::: W|
| ----------- |
|p ui|   :>#v,mv’mm:’emz,v/|p|ne f :y|p.zh|,mzh|
|wxypf ,ua|kn:u|whN>|uv:z\\\|/ zb p:  \zkqH s|> |\J:|g>,,\|s.f |
| ----------- |
|ap/ /lo\ im|jpe, #i-yol.’>|,b’|a -b|gwj|q zhj|s>  WgF-|y,-|qQ a |f ’’’.>>#\>’d- |\.|# ,#H>’| /|>>-,y #|x:| i| #| t|y>n -|\ph|:f/ |p|z- ,|cbi\| ’r|  ||,,|y#tw|sh|z:hs/>un| |b/s\co|cv>\>| w|jP|Pd->|.\\-/ |\  i#p-|,#, | kq-- n,|b |,--lchb,|y :o| F  : >  p l |
| ----------- |
|\Acz|q  |\>k\>u/|x|---```	 ```|x.|./z| s’ SY-|xqv:o|lu#|K:-,a>t|pt|
| ----------- |
|z|- pu').
	oracle := ShinMethodCallsOracle new
		threshold: 0.9;
		methodsToInstrument: Microdown package methods;
		evalBlock: [ :input | Microdown parse: input ].

	tests := cases collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
