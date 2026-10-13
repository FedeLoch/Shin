"
The coverage oracle instruments code with metalinks on every evaluation. These tests check
that it keeps working when Pharo flushes its AST cache and that it never leaves metalinks
installed behind it.
"
Class {
	#name : 'ShinCoverageOracleTest',
	#superclass : 'TestCase',
	#instVars : [
		'oracle'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'helpers' }
ShinCoverageOracleTest >> installedCoverageLinks [

	^ MetaLink allInstances select: [ :link | link selector = #tagExecuted and: [ link nodes notEmpty ] ]
]

{ #category : 'running' }
ShinCoverageOracleTest >> setUp [

	super setUp.
	oracle := ShinCoverageOracle new
		          methodsToInstrument: RxMatcher package methods;
		          evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ];
		          yourself
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testASTCacheResetDuringASessionIsHarmless [

	oracle during: [ | before |
		before := oracle evalInput: 'a+|'.
		ASTCache reset.
		self denyEmpty: before.
		self assert: (oracle evalInput: 'a+|') equals: before ]
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testASessionGivesTheSameCoverageAsSingleEvaluations [

	| alone inSession |
	alone := { oracle evalInput: 'a+|'. oracle evalInput: '(a)*.*.' }.

	inSession := oracle during: [ { oracle evalInput: 'a+|'. oracle evalInput: '(a)*.*.' } ].

	self assert: inSession equals: alone.
	self deny: alone first = alone second
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testASessionInstallsTheMetalinksOnce [

	oracle during: [
		self denyEmpty: self installedCoverageLinks.
		oracle evalInput: 'a+|'.
		oracle evalInput: 'a+|'.
		self assert: self installedCoverageLinks size equals: 1 ].

	self assertEmpty: self installedCoverageLinks
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testAcceptsInputsWithTheSameCoverage [

	| baseline |
	baseline := oracle evalInput: 'a+|'.

	self assert: (oracle accepts: 'a+|' from: baseline).
	self deny: (oracle accepts: '(a)*.*.' from: baseline).
	self deny: (oracle accepts: '(' from: baseline)
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testCoverageSurvivesAnASTCacheReset [

	"Pharo 14 holds ASTs weakly and flushes them on image save: a reused CoverageCollector
	then reports an empty node coverage"
	| before |
	before := oracle evalInput: 'a+|'.

	ASTCache reset.

	self denyEmpty: before.
	self assert: (oracle evalInput: 'a+|') equals: before
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testEvaluationLeavesNoMetalinkInstalled [

	oracle evalInput: 'a+|'.

	self assertEmpty: self installedCoverageLinks.
	self deny: (RxMatcher package methods anySatisfy: [ :method | method isKindOf: ReflectiveMethod ])
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testFailingEvaluationLeavesNoMetalinkInstalled [

	self deny: (oracle accepts: '(' from: Set new).

	self assertEmpty: self installedCoverageLinks.
	self deny: (RxMatcher package methods anySatisfy: [ :method | method isKindOf: ReflectiveMethod ])
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testFailingSessionLeavesNoMetalinkInstalled [

	[ oracle during: [ oracle evalInput: 'a+|'. Error signal: 'boom' ] ] on: Error do: [ :e | e return: nil ].

	self assertEmpty: self installedCoverageLinks.
	self deny: (RxMatcher package methods anySatisfy: [ :method | method isKindOf: ReflectiveMethod ])
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testInterruptedEvaluationLeavesNoMetalinkInstalled [

	| process |
	process := [ oracle evalInput: 'a+|' ] forkAt: Processor userBackgroundPriority.
	[ self installedCoverageLinks isEmpty ] whileTrue: [ (Delay forMilliseconds: 1) wait ].

	"terminated while the metalinks are being installed"
	process terminate.
	(Delay forMilliseconds: 100) wait.

	self assertEmpty: self installedCoverageLinks.
	self deny: (RxMatcher package methods anySatisfy: [ :method | method isKindOf: ReflectiveMethod ])
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testInterruptedSessionLeavesNoMetalinkInstalled [

	| gate process |
	gate := Semaphore new.
	process := [ oracle during: [ oracle evalInput: 'a+|'. gate wait ] ] forkAt: Processor userBackgroundPriority.
	[ self installedCoverageLinks isEmpty ] whileTrue: [ (Delay forMilliseconds: 1) wait ].

	process terminate.
	(Delay forMilliseconds: 100) wait.

	self assertEmpty: self installedCoverageLinks.
	self deny: (RxMatcher package methods anySatisfy: [ :method | method isKindOf: ReflectiveMethod ])
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testSeveralOraclesGiveTheSameCoverage [

	| other |
	other := ShinCoverageOracle new
		         methodsToInstrument: RxMatcher package methods;
		         evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ];
		         yourself.

	self assert: (other evalInput: 'a+|') equals: (oracle evalInput: 'a+|').
	self assert: (oracle evalInput: 'a+|') equals: (other evalInput: 'a+|')
]

{ #category : 'tests' }
ShinCoverageOracleTest >> testShrinkingUsesOneSessionPerReduction [

	| collectors shrinker result |
	collectors := IdentitySet new.
	oracle evalBlock: [ :regex |
		collectors add: (oracle instVarNamed: #collector).
		regex asRegex matches: regex minimalStringMatching ].
	shrinker := ShinDDminFuzzingBookShrinker new oracle: oracle; yourself.

	result := shrinker profiledShrink: 'b+bc||'.

	self assert: collectors size equals: 1.
	self assert: (result at: 'neededReductions') > 0.
	self assert: (result at: 'minimizedBound') equals: (result at: 'originalBound').
	self assertEmpty: self installedCoverageLinks
]
