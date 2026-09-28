Extension { #name : 'Duration' }

{ #category : '*Shin' }
Duration >> neoJsonOn: neoJSONWriter [

	neoJSONWriter writeString: (self humanReadablePrintString)
]
