"
Properties every flat (string / array) reducer must satisfy. Each test runs once per reducer
listed in #testParameters.
"
Class {
	#name : 'ShinFlatReducerPropertyTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'shrinkerClass',
		'calls'
	],
	#category : 'Shin-Shrinker Tests',
	#package : 'Shin',
	#tag : 'Shrinker Tests'
}

{ #category : 'building suites' }
ShinFlatReducerPropertyTest class >> testParameters [

	^ ParametrizedTestMatrix new
		  forSelector: #shrinkerClass
		  addOptions: {
				  ShinDDminPaperShrinker.
				  ShinDDminFuzzingBookShrinker.
				  ShinProbDDShrinker.
				  ShinCDDShrinker.
				  ShinWDDminShrinker.
				  ShinWDDProbShrinker };
		  yourself
]

{ #category : 'asserting' }
ShinFlatReducerPropertyTest >> assertOneMinimal: result for: block [

	"No single element can be removed from result while preserving the behavior"
	1 to: result size do: [ :index | | smaller |
		smaller := (result copyFrom: 1 to: index - 1) , (result copyFrom: index + 1 to: result size).
		self
			deny: (block value: smaller)
			description: [ shrinkerClass name , ': ' , result printString , ' is not 1-minimal, ' , smaller printString , ' also works' ] ]
]

{ #category : 'asserting' }
ShinFlatReducerPropertyTest >> assertShrinking: input with: block equals: expected [

	| result |
	result := self shrink: input with: block.
	self
		assert: result = expected
		description: [ shrinkerClass name , ': expected ' , expected printString , ' but got ' , result printString ]
]

{ #category : 'helpers' }
ShinFlatReducerPropertyTest >> countingOracle: block [

	calls := 0.
	^ ShinBooleanInputOracle from: [ :input |
		calls := calls + 1.
		block value: input ]
]

{ #category : 'helpers' }
ShinFlatReducerPropertyTest >> monotonicCases [

	"input -> oracle. With monotonic oracles (supersets of a failing input fail too)
	every reducer, including the probabilistic ones, must reach a 1-minimal result."
	^ {
		  'asqjjkqsbdvieqvsbdoivbq' -> [ :s | s includes: $e ].
		  'kjdsfhkjqsdhfehdkjsqfhkjsa' -> [ :s | (s includes: $e) and: [ s includes: $a ] ].
		  'zzbzzuzzgzzbugzz' -> [ :s | s includesSubstring: 'bug' ].
		  'xbxaxbxaxbx' -> [ :s | (s indexOf: $a) > 0 and: [ (s indexOf: $b startingAt: (s indexOf: $a)) > 0 ] ].
		  '1+(2*3)-(4/5)' -> [ :s | (s occurrencesOf: $() >= 2 ] }
]

{ #category : 'accessing' }
ShinFlatReducerPropertyTest >> shrinkerClass [

	^ shrinkerClass
]

{ #category : 'accessing' }
ShinFlatReducerPropertyTest >> shrinkerClass: aClass [

	shrinkerClass := aClass
]

{ #category : 'helpers' }
ShinFlatReducerPropertyTest >> shrink: input with: block [

	^ (shrinkerClass new oracle: (ShinBooleanInputOracle from: block); yourself) shrink: input
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testAlreadyMinimalInputIsUnchanged [

	self assertShrinking: 'e' with: [ :s | s includes: $e ] equals: 'e'.
	self assertShrinking: 'ab' with: [ :s | (s includes: $a) and: [ s includes: $b ] ] equals: 'ab'
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testArraysStayArrays [

	| result |
	result := self shrink: #( 1 2 3 4 5 6 7 8 ) with: [ :input | input includes: 4 ].

	self assert: result equals: #( 4 )
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testFindsTheSingleRelevantCharacter [

	self assertShrinking: 'asqjjkqsbdvieqvsbdoivbq' with: [ :s | s includes: $e ] equals: 'e'.
	self assertShrinking: '1+(2*3)' with: [ :s | s includes: $3 ] equals: '3'
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testFindsTwoRelevantCharacters [

	self
		assertShrinking: 'kjdsfhkjqsdhfehdkjsqfhkjsa'
		with: [ :s | (s includes: $e) and: [ s includes: $a ] ]
		equals: 'ea'
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testFindsASubstring [

	self assertShrinking: 'zzbzzuzzgzzbugzz' with: [ :s | s includesSubstring: 'bug' ] equals: 'bug'
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testIsDeterministic [

	| block |
	block := [ :s | (s includes: $e) and: [ s includes: $a ] ].

	self
		assert: (self shrink: 'kjdsfhkjqsdhfehdkjsqfhkjsa' with: block)
		equals: (self shrink: 'kjdsfhkjqsdhfehdkjsqfhkjsa' with: block)
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testKeepsRelativeOrder [

	self
		assertShrinking: 'xbxaxbxaxbx'
		with: [ :s | (s indexOf: $a) > 0 and: [ (s indexOf: $b startingAt: (s indexOf: $a)) > 0 ] ]
		equals: 'ab'
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testOracleOnlyReceivesInputsOfTheOriginalKind [

	| kinds |
	kinds := Set new.
	self shrink: 'asqjjkqsbdvieqvsbdoivbq' with: [ :s | kinds add: s class. s includes: $e ].

	self assert: (kinds allSatisfy: [ :kind | kind includesBehavior: String ])
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testRemovesOneOfTwoEqualElements [

	"Only the trailing $a can go: removing one $a must not remove every $a"
	self
		assertShrinking: 'aba'
		with: [ :s | s notEmpty and: [ s first = $a and: [ s includes: $b ] ] ]
		equals: 'ab'
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testReportsEveryOracleCall [

	| shrinker result |
	shrinker := shrinkerClass new oracle: (self countingOracle: [ :s | (s includes: $e) and: [ s includes: $a ] ]); yourself.

	result := shrinker profiledShrink: 'kjdsfhkjqsdhfehdkjsqfhkjsa'.

	"profiledShrink: evaluates the original and the minimized input once more"
	self assert: (result at: 'neededReductions') equals: calls - 2.
	self assert: (result at: 'failedReductions') <= (result at: 'neededReductions')
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testResultIsOneMinimal [

	self monotonicCases do: [ :case | | result |
		result := self shrink: case key with: case value.
		self assert: (case value value: result) description: [ shrinkerClass name , ' lost the behavior on ' , case key ].
		self assertOneMinimal: result for: case value ]
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testShrinksRepeatedElements [

	self assertShrinking: 'eeeeeeeeeeeeeeeeeeeeeeeeee' with: [ :s | s includes: $e ] equals: 'e'.
	self assertShrinking: 'abababab' with: [ :s | s includesSubstring: 'ba' ] equals: 'ba'
]

{ #category : 'tests' }
ShinFlatReducerPropertyTest >> testTerminatesOnSmallInputs [

	#( 'abcd' 'abcdefgh' 'xxbxx' 'qwertyuiopb' 'b' ) do: [ :input |
		self assertShrinking: input with: [ :s | s includes: $b ] equals: 'b' ]
]
