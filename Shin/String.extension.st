Extension { #name : 'String' }

{ #category : '*Shin' }
String >> minimalStringMatching [

    ^ (RxParser parse: self) minimalString
]
