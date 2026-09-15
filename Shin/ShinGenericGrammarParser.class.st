Class {
	#name : 'ShinGenericGrammarParser',
	#superclass : 'Object',
	#instVars : [
		'memo'
	],
	#category : 'Shin-Parsing',
	#package : 'Shin',
	#tag : 'Parsing'
}

{ #category : 'parsing' }
ShinGenericGrammarParser class >> accept: string from: grammar [

	^ (self parse: string from: grammar) isNil not 
]

{ #category : 'parsing' }
ShinGenericGrammarParser class >> parse: string from: grammar [

	| parsingResult |
	parsingResult := self new parseNonTerminal: grammar start on: string from: 0.

	parsingResult ifNil: [ ^ nil ].
	
	(parsingResult second ~= string size) ifTrue: [ ^ nil ].
	
	^ parsingResult first
]

{ #category : 'parsing' }
ShinGenericGrammarParser >> best: best candidate: candidate [
	
	best ifNil: [ ^ candidate ].
	
	^ ((best first inputSize) < candidate first inputSize) ifTrue: [ candidate ] ifFalse: [ best ]
]

{ #category : 'parsing' }
ShinGenericGrammarParser >> initialize [

	super initialize.
	memo := Dictionary new.
]

{ #category : 'parsing' }
ShinGenericGrammarParser >> parseNonTerminal: nonTerminal on: input from: index [

	| key cached best |
    key := { nonTerminal name . index }.
    cached := memo at: key ifAbsent: [ nil ].
    cached ifNotNil: [ ^ {cached first doCopy . cached second } ].

    best := nil.

    nonTerminal rules do: [ :rule | | result candidate |
        result := self parseRule: rule on: input from: index.
        result ifNotNil: [
				candidate := GncInnerNode new tag: nonTerminal name; grammarRule: rule; children: result first.
				result at: 1 put: candidate.
            best := self best: best candidate: result
        ].
    ].

    memo at: key put: best.

    ^ best
]

{ #category : 'parsing' }
ShinGenericGrammarParser >> parseRule: rule on: input from: index [

	| children currentIndex |
	children := OrderedCollection new.
	currentIndex := index.

	rule fragments do: [ :fragment | | result |
		result := fragment parse: input from: currentIndex with: self rule: rule.
		result ifNil: [ ^ nil ].
		children add: result first.
		currentIndex := result second
	].

	^ { children . currentIndex }
]

{ #category : 'parsing' }
ShinGenericGrammarParser >> parseTerminal: terminal on: string from: index rule: rule [

    | token |

    token := terminal consume: string from: index.

    token ifNil: [ ^ nil ].

    ^ { (GncLeaf withToken: token) grammarRule: rule . index + token size }
]
