Class {
	#name : 'ShinDDminPaperShrinker',
	#superclass : 'ShinShrinker',
	#instVars : [
		'splittingValue',
		'seen',
		'source'
	],
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> asInput: aString [

	^ aString
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> candidates: cFail minus: cPass partition: n at: i [

	| elements from to |

	"used by general delta debugging"

	elements := self positions: cFail minus: cPass.

	from := i - 1 * elements size // n + 1.
	to := i * elements size // n.

	^ elements copyFrom: from to: to
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> candidates: cFail partition: n at: i [

	| from to |

	"used by minimizing delta debugging"
	from := i - 1 * cFail size // n + 1.
	to := i * cFail size // n.

	^ cFail copyFrom: from to: to
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> dd2: cFail safe: cPass upperBound: bound granularity: n [
	"Paper: https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf"

    | deltaSize range key |

    deltaSize := (self positions: cFail minus: cPass) size.

	 key := { cFail . cPass . n }.

    (seen includes: key) ifTrue: [ ^ { cPass . cFail } ].
    seen add: key.

    range := 1 to: n.

    "Reduce to subset"
    range do: [ :i | | deltaI current |
		  deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  current := self positions: cPass plus: deltaI.

        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self dd2: current safe: cPass upperBound: bound granularity: 2
        	]
    ].

    "Increase to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  	current := self positions: cFail minus: deltaI.
        	(self triggerBug: current upperBound: bound) ifFalse: [
            	^ self dd2: cFail safe: current upperBound: bound granularity: 2
        	]
    ].

    "Increase to subset"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  	current := self positions: cPass plus: deltaI.

        	(self triggerBug: current upperBound: bound) ifFalse: [
            	^ self dd2: cFail safe: current upperBound: bound granularity: ((n - 1) max: 2)
        	]
    ].

    "Reduce to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
			current := self positions: cFail minus: deltaI.

        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self dd2: current safe: cPass upperBound: bound granularity: ((n - 1) max: 2)
       	]
    ].

    "Increase granularity"
    n < deltaSize ifTrue: [
        ^ self dd2: cFail safe: cPass upperBound: bound granularity: ((2 * n) min: deltaSize)
    ].

    ^ { cPass . cFail }
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> dd: cFail upperBound: bound [

	| resultPair |

	seen := Set new.
	source := cFail.

	"First is the safe array subset"
	"Second is the minimum array subset taht triggers the bug"

	"General delta debugging algorithm"
	resultPair := self dd2: (1 to: cFail size) asArray safe: #() upperBound: bound granularity: 2.

	^ self elementsOf: source at: resultPair second
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> ddmin2: cFail upperBound: bound granularity: n [
	"Paper: https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf"

    | range key |

	 key := { cFail . n }.

    (seen includes: key) ifTrue: [ ^ cFail ].
    seen add: key.

    range := 1 to: n.

    "Reduce to subset"
    range do: [ :i | | deltaI |
		  deltaI := self candidates: cFail partition: n at: i.
			self minimizationDone.
        	(self triggerBug: deltaI upperBound: bound) ifTrue: [
            	^ self ddmin2: deltaI upperBound: bound granularity: 2
        	] ifFalse: [ self failedMinimization ]
    ].

    "Reduce to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail partition: n at: i.
			current := self positions: cFail minus: deltaI.
			self minimizationDone.
        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self ddmin2: current upperBound: bound granularity: ((n - 1) max: 2)
       	] ifFalse: [ self failedMinimization ]
    ].

    "Increase granularity"
    n < (cFail size) ifTrue: [
        ^ self ddmin2: cFail upperBound: bound granularity: ((2 * n) min: (cFail size))
    ].

    ^ cFail
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> ddmin: cFail upperBound: bound [

	| minimized |

	seen := Set new.
	source := cFail.

	minimized := self ddmin2: (1 to: cFail size) asArray upperBound: bound granularity: 2.

	^ self elementsOf: source at: minimized
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> initialize [

	super initialize.
	seen := Set new
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> minimizeOne: aInput upperBound: bound [

	^ self minimizeOnePaper: aInput upperBound: bound
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> minimizeOnePaper: cFail upperBound: bound [

	"General algorithm"
	"^ self dd: cFail upperBound: bound."

	"Ddmin classic"
	^ self ddmin: cFail upperBound: bound
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> positions: someIndices minus: indicesToRemove [

	| toRemove |

	toRemove := indicesToRemove asSet.
	^ someIndices reject: [ :index | toRemove includes: index ]
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> positions: someIndices plus: otherIndices [

	^ (someIndices asSet addAll: otherIndices; yourself) asSortedCollection asArray
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> sizeOf: string [

	^ string size

]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> tree: aString [

	^ aString.
]

{ #category : 'shrinking' }
ShinDDminPaperShrinker >> triggerBug: indices upperBound: originalScore [

	"indices are positions in the input being minimized"
	^ oracle accepts: (self asInput: (self elementsOf: source at: indices)) from: originalScore
]
