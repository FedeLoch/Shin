Extension { #name : 'RxsCharSet' }

{ #category : '*Shin' }
RxsCharSet >> minimalString [

	^ '''' join: (elements collect: [ :node | node minimalString ])
]
