Class {
	#name : 'ShinMicrodownCuratedPerformanceBenchmark',
	#superclass : 'ShinShrinkingMicrodownPerformanceBenchmark',
	#category : 'Shin',
	#package : 'Shin'
}

{ #category : 'initialization' }
ShinMicrodownCuratedPerformanceBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := ExtendedMarkdownGrammar new.
	cases := #( 'a' '|#|#|j|g.gdl./tqd | /\
v i fu# |m cs Tz h\\ :vJq|,n\u2019ps/k|vy| t cm#q|d|q|-x--:U.:/#,\\|
| -----------| -----------| ----------- |
|w#/ > o f  Wx|

\t
\t|:.|-|#xaz|l:e|X|c|#qmw:| >|,tucV/ |
| ----------- |
|.crmflc#Mjwy/h|:grg|u|sVte|\t ~  Wcgl       zcuyrzs~###
//.#eCvcrq

\t
@i-@
 `ee v``.X\\a/o ``w  p`-bs*\
\u2019r>wh*`c`\\,i
\t`tk`` t /p,/\u2019Wf,ondpn- `yw/>*,lr\u2019hc.>c>-: qla>>l*`jwo  md\u2019u` d`wJb d\u2019   ler`[//buOk>g]( sr)@xx \\t@q icm`-.`qj xln >#`fhm/` \t  |Mf -Uy ov|w\\oxg|u g\\\\#|-Qgxp#um,vea::: W|
| ----------- |
|p ui|   :>#v,mv\u2019mm:\u2019emz,v/|p|ne f :y|p.zh|,mzh|
|wxypf ,ua|kn:u|whN>|uv:z\\\\\\|/ zb p:  \\zkqH s|> |\\J:|g>,,\\|s.f |
| ----------- |
|ap/ /lo\\ im|jpe, #i-yol.\u2019>|,b\u2019|a -b|gwj|q zhj|s>  WgF-|y,-|qQ a |f \u2019\u2019\u2019.>>#\\>\u2019d- |\\.|# ,#H>\u2019| /|>>-,y #|x:| i| #| t|y>n -|\\ph|:f/ |p|z- ,|cbi\\| \u2019r|  ||,,|y#tw|sh|z:hs/>un| |b/s\\co|cv>\\>| w|jP|Pd->|.\\\\-/ |\\  i#p-|,#, | kq-- n,|b |,--lchb,|y :o| F  : >  p l |
| ----------- |
|\\Acz|q  |\\>k\\>u/|x|---```\t ```|x.|./z| s\u2019 SY-|xqv:o|lu#|K:-,a>t|pt|
| ----------- |
|z|- pu' 'Sm\\:#, jiG

`.duyk`
\t\t
\t- [x] /E #
- [x]\t .ts ,f
- [ ] fpt
- [x] G
- [x] okPmp/aiv
- [x] > \\,cG,k hm
- [x]\ta:f 
- [x]\te 
- [x]
/j l 
- [x] og
- [x]\tf 
- [x]
vavyh/Bwl,wQc G ,oe.\\#\\
- [x] :vb 
- [x] b 
- [ ]
ppgry
- [x]
yaC
- [x]
 w-/o g 
- [x]\t 
- [x]
ps b:xe#ykB 
- [x]\t c,j:f\u2019E
- [x]\tnsef
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
- [x]\tf
- [x]
 -
- [ ]\t.d>
- [x]\t- \\n  >f-:
- [ ]\t, ,
- [x]
,-\\d
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
lw \\
- [x]
  v> 
- [ ]
\\-
- [x]
t y-t
- [x]
--l#x  g-
- [x]
   --r- -     >
- [x]
  
- [x]
 m.
- [x]\t 
- [x]\tjhv
- [x]
 :-.
- [x]\t:> :
- [x] v
- [x] a
- [x]
-
- [x]\t/
- [x]
-\\\u2019,
- [x]
,
- [x]
--->
- [x]\t 
- [x]
#,,
- [x]
I>#
- [x]
#, \\
- [x]
>\\: ,' ).
	oracle := ShinMethodCallsOracle new
		          threshold: 0.9;
		          methodsToInstrument: Microdown package methods;
		          evalBlock: [ :input | Microdown parse: input ].

	tests := cases collect: [ :input | ShinShrinkerTest input: input oracle: oracle ]
]
