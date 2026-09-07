Class {
	#name : 'ShinShrinkingBenchmarkReport',
	#superclass : 'Object',
	#instVars : [
		'results'
	],
	#category : 'Shin-Benchmarks',
	#package : 'Shin',
	#tag : 'Benchmarks'
}

{ #category : 'adding' }
ShinShrinkingBenchmarkReport >> add: result for: shrinkerClass [

	results at: shrinkerClass name put: result
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> asPlots: section [ 

	| plt p colors count popup |
	plt := RSChart new.
	colors := { Color blue . Color red . Color green . Color orange . Color purple . Color cyan }.
	
	popup := RSPopupDecoration new.
   plt addDecoration: popup.

	count := results size.
	colors := (1 to: count) collect: [ :i | 
        Color 
            h: ((i - 1) * 360 / (count max: 1))
            s: 0.75
            v: 0.85
    ].
	
	results doWithIndex: [ :data :index | | shape y |
		y := (self collectResult: data for: section).
		p := RSLinePlot new x: ( 1 to: data size ) y: y.
		p color: (colors at: index).
		shape := RSEllipse new size: 4; color: (colors atWrap: index).
		p marker: shape.
		plt add: p.
		popup chartPopupBuilder 
            for: p 
            color: (colors at: index).
	].

	plt xlabel: 'test number';
	yLog; 
	ylabel: section, ' (log)';
	title: section, ' benchmark'.
	
	plt horizontalTick numberOfTicks: ((results anyOne size) min: 10).
	plt horizontalTick labelConversion: [ :val | val rounded ].
	
	( section = '%inputReduction'  or: section = '%problemPreservation' ) ifTrue: [ 
		plt minChartValueY: 0;
		maxChartValueY: 100  ]. 
	
	plt build.
	
	self buildLegend: plt with: section palette: colors. 

	^ plt canvas 
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> buildLegend: plot with: section palette: colors [
	
	| legend |
	
	legend := RSLegend new.
	legend container: plot canvas;
	title: 'Legend'.
	
	results doWithIndex: [ :data :index |
		| name |
		name := (results keyAtValue: data) asString.
		legend text: name withBoxColor: (colors at: index)
	].
	
   legend legendDo: [ :legendName | 
        legendName withBorder; padding: 10 ].
    legend location right; middle; offset: 10@0.
    legend build.
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> collectResult: result for: section [

	( section = 'totalTime' ) ifTrue: [ 
		^ result collect: [ :aResultAssociation | (aResultAssociation at: section) asMicroseconds ]  ].
	
	^ result collect: [ :aResultAssociation | aResultAssociation at: section ]
]

{ #category : 'adding' }
ShinShrinkingBenchmarkReport >> initialize [ 
	
	super initialize.
	results := Dictionary new.
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> plotFailedReductions [

	^ (self asPlots: 'failedReductions') open
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> plotInputReduction [

	^ (self asPlots: '%inputReduction') open
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> plotNeededReductions [

	^ (self asPlots: 'neededReductions') open
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> plotProblemPreservation [

	^ (self asPlots: '%problemPreservation') open
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> plotTotalTime [

	^ (self asPlots: 'totalTime' ) open
]

{ #category : 'as yet unclassified' }
ShinShrinkingBenchmarkReport >> saveAsFile: fileName [

	(fileName asFileReference) writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: results)
	] 
]
