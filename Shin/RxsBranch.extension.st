Extension { #name : 'RxsBranch' }

{ #category : '*Shin' }
RxsBranch >> minimalString [

	^ piece minimalString, (branch ifNil: [ '' ] ifNotNil: [ branch minimalString ])
]
