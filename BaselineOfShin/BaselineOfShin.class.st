Class {
	#name : 'BaselineOfShin',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfShin',
	#package : 'BaselineOfShin'
}

{ #category : 'baselines' }
BaselineOfShin >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec baseline: 'Gnocco' with: [ spec repository: 'github://Alamvic/gnocco:release/src' ].
		"spec baseline: 'Mate' with: [ spec repository: 'github://FedeLoch/Mate:main' ]."
		
		spec package: 'Shin' with: [ spec requires: #( 'Gnocco' ) ].
	]
]
