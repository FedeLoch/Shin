Class {
	#name : 'ShinCoverageOracle',
	#superclass : 'ShinThresholdOracle',
	#instVars : [
		'evalBlock',
		'methodsToInstrument'
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
ShinCoverageOracle >> evalInput: input [

	"A fresh collector is built for every evaluation. A CoverageCollector computes its
	sequence nodes once from `CompiledMethod>>ast`, and the AST cache only holds ASTs weakly
	and is flushed on image save or `ASTCache reset`: a reused collector then links nodes
	that are no longer the compiled AST and reports an empty coverage forever.
	The installation happens inside the protected block so that a run interrupted while
	installing does not leave metalinks behind."

	| collector |
	
	collector := CoverageCollector new methods: self currentMethods.
	[
		collector install.
		collector reset.
		evalBlock value: input ] ensure: [ collector uninstall ].

	^ collector collectResult nodes collect: #asString as: Set
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
