Class {
	#name : 'ShinShrinker',
	#superclass : 'Object',
	#instVars : [
		'maxIterations',
		'reductionsDone',
		'failedReductionsDone',
		'oracle',
		'grammar'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinShrinker >> asInput: tree [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
ShinShrinker >> checkGrammar: aInput [

	^ GncGenericGrammarParser accept: aInput from: grammar
]

{ #category : 'shrinking' }
ShinShrinker >> countingCallsOf: aReducer during: aBlock [

	"Run aBlock and add the reductions aReducer performed meanwhile to my own counters,
	so a composite shrinker reports every oracle call made on its behalf exactly once."

	| done failed result |
	done := aReducer getMinimizationDone.
	failed := aReducer getFailedMinimization.
	result := aBlock value.
	self minimizationDone: aReducer getMinimizationDone - done.
	self failedMinimization: aReducer getFailedMinimization - failed.
	^ result
]

{ #category : 'shrinking' }
ShinShrinker >> elementsOf: source at: indices [

	"Answer the elements of source at the given positions, in input order and with the
	species of source (a String stays a String). Flat shrinkers reason about positions
	rather than values so that repeated elements can be removed independently."

	^ source species withAll: (indices asSortedCollection asArray collect: [ :index | source at: index ])
]

{ #category : 'shrinking' }
ShinShrinker >> emptyProfiledResult: input [

	^ {
		'originalInput' -> input.
		'minimizedInput' -> input.
		'totalTime' -> (Duration microSeconds: 0).
		'neededReductions' -> 0.
		'failedReductions' -> 0.
		'%problemPreservation' -> 100.
		'%inputReduction' -> 0.
		'originalBound' -> nil.
		'minimizedBound' -> nil
	} asDictionary
]

{ #category : 'shrinking' }
ShinShrinker >> evalInput: input [

	"Returns true if the input triggers the bug, otherwise, it returns false"
	^ oracle evalInput: input
]

{ #category : 'shrinking' }
ShinShrinker >> failedMinimization [

	failedReductionsDone := failedReductionsDone + 1
]

{ #category : 'shrinking' }
ShinShrinker >> failedMinimization: number [

	failedReductionsDone := failedReductionsDone + number
]

{ #category : 'shrinking' }
ShinShrinker >> getFailedMinimization [

	^ failedReductionsDone
]

{ #category : 'shrinking' }
ShinShrinker >> getMinimizationDone [

	^ reductionsDone
]

{ #category : 'shrinking' }
ShinShrinker >> grammar [
	
	^ grammar
]

{ #category : 'shrinking' }
ShinShrinker >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'testing' }
ShinShrinker >> initialize [ 
	
	super initialize.
	maxIterations := 1.
	reductionsDone := 0.
	failedReductionsDone := 0.
]

{ #category : 'shrinking' }
ShinShrinker >> maxIterations: nbIterations [

	maxIterations := nbIterations
]

{ #category : 'shrinking' }
ShinShrinker >> minimizationDone [

	reductionsDone := reductionsDone + 1
]

{ #category : 'shrinking' }
ShinShrinker >> minimizationDone: number [

	reductionsDone := reductionsDone + number
]

{ #category : 'shrinking' }
ShinShrinker >> minimizeOne: tree upperBound: bound [

	"Each sublclass must call:
		self minimizationDone -> each time it proceeds to do a reduction ( failed or not )
		self failedMinimization -> each time it proceeds to do a failed reduction
	"
	self subclassResponsibility
]

{ #category : 'shrinking' }
ShinShrinker >> minimizeTree: tree upperBound: bound [

	| currentTree currentSize |
	
	reductionsDone := 0.
	failedReductionsDone := 0.
	self resetState.

	currentTree := tree copy.
	currentSize := self sizeOf: currentTree.
	maxIterations timesRepeat: [ | minimized size |
		minimized := self minimizeOne: currentTree upperBound: bound.
		size := self sizeOf: minimized.
		
		(self shouldStop: minimized size: size from: currentTree size: currentSize) ifTrue: [ ^ currentTree ].
		
		currentTree := minimized.
		currentSize := size
	].

	^ currentTree
]

{ #category : 'shrinking' }
ShinShrinker >> oracle [ 
	
	^ oracle 
]

{ #category : 'shrinking' }
ShinShrinker >> oracle: anOracle [

	oracle := anOracle
]

{ #category : 'shrinking' }
ShinShrinker >> percentageInputReduced: tree given: minimizedTree [

	| initialNumOfNodes currentNumOfNodes |
	initialNumOfNodes := self sizeOf: tree.
	currentNumOfNodes := self sizeOf: minimizedTree.

	^ (100 - ((currentNumOfNodes * 100) / initialNumOfNodes)) asFloat
]

{ #category : 'shrinking' }
ShinShrinker >> percentageProblemPreservation: upperBound given: currentBound [

	^ self oracle percentageProblemPreservation: upperBound given: currentBound
]

{ #category : 'shrinking' }
ShinShrinker >> profiledShrink: input [

	| tree minimizedTree upperBound initialTime totalTime minimizedInput minimizedBound |
	
	initialTime := Time microsecondClockValue.
	(self tree: input) ifNil: [ self emptyProfiledResult: input ].

	"One oracle session for the whole reduction (e.g. coverage instrumentation is installed once)"
	oracle during: [
		upperBound := self evalInput: input.

		tree := self tree: input.
	
		minimizedTree := self minimizeTree: tree upperBound: upperBound.	
		totalTime := Time microsecondClockValue - initialTime.
		minimizedInput := self asInput: minimizedTree.
		minimizedBound := self evalInput: minimizedInput ].

	^ {
		'originalInput' -> input.
		'minimizedInput' -> minimizedInput.
		'totalTime' -> (Duration microSeconds: totalTime).
		'neededReductions' -> reductionsDone asFloat.
		'failedReductions' -> failedReductionsDone asFloat.
		'%problemPreservation' -> (self percentageProblemPreservation: upperBound given: minimizedBound).
		'%inputReduction' -> (self percentageInputReduced: tree given: minimizedTree).
		'originalBound' -> upperBound.
		'minimizedBound' -> minimizedBound
	} asDictionary
]

{ #category : 'shrinking' }
ShinShrinker >> resetState [

	"Hook called before each reduction so that no state of a previous run leaks into the next one"
]

{ #category : 'tree editing' }
ShinShrinker >> setChildrenOf: parent to: someChildren [

	"Replace the children of parent and propagate the size difference to its ancestors.
	GncInnerNode>>children: only recomputes the parent's own treeSize, so restoring
	children with it after a removeChild: leaves every ancestor with a stale treeSize."

	| oldSize |
	oldSize := parent treeSize.
	parent children: (OrderedCollection withAll: someChildren).
	parent parent ifNotNil: [ :grandParent |
		grandParent increaseTreeSizeBy: parent treeSize - oldSize ]
]

{ #category : 'shrinking' }
ShinShrinker >> shouldStop: minimized size: size from: currentTree size: currentSize [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
ShinShrinker >> shrink: input [

	| tree minimizedTree upperBound |

	(self tree: input) ifNil: [ ^ input ].

	"One oracle session for the whole reduction (e.g. coverage instrumentation is installed once)"
	^ oracle during: [
		upperBound := self evalInput: input.

		tree := self tree: input.
		minimizedTree := self minimizeTree: tree upperBound: upperBound.

		self asInput: minimizedTree ]
]

{ #category : 'shrinking' }
ShinShrinker >> sizeOf: tree [

	^ tree allNodes size
]

{ #category : 'shrinking' }
ShinShrinker >> tree: input [

	self  subclassResponsibility 
]

{ #category : 'testing' }
ShinShrinker >> triggerBug: tree upperBound: originalScore [

	| input |
	
	input := self asInput: tree.

	^ [
		  (oracle accepts: input from: originalScore) and: [
			  self checkGrammar: input ] ]
		  on: Error
		  do: [ :error | false ]
]
