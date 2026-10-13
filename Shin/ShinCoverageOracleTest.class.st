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
ShinCoverageOracleTest >> testSeveralOraclesGiveTheSameCoverage [

	| other |
	other := ShinCoverageOracle new
		         methodsToInstrument: RxMatcher package methods;
		         evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ];
		         yourself.

	self assert: (other evalInput: 'a+|') equals: (oracle evalInput: 'a+|').
	self assert: (oracle evalInput: 'a+|') equals: (other evalInput: 'a+|')
]
