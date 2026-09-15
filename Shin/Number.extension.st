Extension { #name : 'Number' }

{ #category : '*Shin' }
Number >> timesCollect: aBlock [
	^ (1 to: self) collect: [ :anIndex | aBlock cull: anIndex ]
]
