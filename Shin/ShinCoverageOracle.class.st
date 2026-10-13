Class {
	#name : 'ShinCoverageOracle',
	#superclass : 'ShinThresholdOracle',
	#instVars : [
		'evalBlock',
		'methodsToInstrument',
		'collector'
	],
	#category : 'Shin-Oracles',
	#package : 'Shin',
	#tag : 'Oracles'
}

{ #category : 'as yet unclassified' }
ShinCoverageOracle >> accepts: input from: baseline [

	| current |
	
	current := [ self evalInput: input ] on: Error do: [ ^ false ].

	^ current = baseline
]

{ #category : 'as yet unclassified' }
ShinCoverageOracle >> currentMethods [

	"Methods can be recompiled (for instance when metalinks are installed or removed), so the
	methods to instrument are looked up again in their class instead of reusing stale ones"
	^ (methodsToInstrument
		   collect: [ :method | method methodClass compiledMethodAt: method selector ifAbsent: [ nil ] ]
		   as: IdentitySet)
		  remove: nil ifAbsent: [  ];
		  yourself
]

{ #category : 'accessing' }
ShinCoverageOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'accessing' }
ShinCoverageOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
ShinCoverageOracle >> during: aBlock [

	"Install the coverage instrumentation once for the whole session, so each evaluation
	only resets and collects the annotations. Installing and removing metalinks is by far
	the most expensive part of an evaluation.
	While the metalinks are installed their ASTs are held by the reflective methods, so a
	flush of the AST cache cannot make the collected nodes stale. The installation happens
	inside the protected block so that an interrupted session never leaves metalinks behind."

	collector ifNotNil: [ ^ aBlock value ].

	collector := CoverageCollector new methods: self currentMethods.
	^ [
	  collector install.
	  aBlock value ] ensure: [
		  collector uninstall.
		  collector := nil ]
]

{ #category : 'as yet unclassified' }
ShinCoverageOracle >> evalInput: input [

	"Outside a session, the evaluation is its own session. A fresh collector is built for
	every session: a CoverageCollector computes its sequence nodes once from
	`CompiledMethod>>ast`, and the AST cache only holds ASTs weakly and is flushed on image
	save or `ASTCache reset`, so a collector reused across sessions would link nodes that are
	no longer the compiled AST and report an empty coverage."

	collector ifNil: [ ^ self during: [ self evalInput: input ] ].

	collector reset.
	evalBlock value: input.

	^ collector basicCollectResult nodes collect: #asString as: Set
]

{ #category : 'initialization' }
ShinCoverageOracle >> initialize [ 

	super initialize.
	methodsToInstrument := #().
	threshold := 1.
]

{ #category : 'accessing' }
ShinCoverageOracle >> methodsToInstrument [ 

	^ methodsToInstrument 
]

{ #category : 'accessing' }
ShinCoverageOracle >> methodsToInstrument: methods [

	methodsToInstrument := methods
]

{ #category : 'shrinking' }
ShinCoverageOracle >> percentageProblemPreservation: upperBound given: currentBound [

	^ 100
]
