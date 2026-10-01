Extension { #name : 'Collection' }

{ #category : '*Shin' }
Collection >> multiply [
	
	^ self inject: 1 into: [ :acc :elem | acc * elem ] 
]
