Class {
	#name : 'ShinSimplifyGrammarBoth',
	#superclass : 'ShinShrinkingStrategy',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'enumerating' }
ShinSimplifyGrammarBoth class >> reduce: subtree using: grammar matching: symbol depth: depth [ 
    
   | candidatesSubtree candidatesAlternate candidates|
    
   candidates := OrderedCollection new.
   candidatesAlternate := ShinSimplifyGrammarAlternateReduction alternateReduction: subtree using: grammar matchingWith: symbol depth: depth .

	candidatesSubtree := ShinSimplifyGrammarSubtreeReducer findSubtree: subtree mathchingWith: symbol depth: depth.
	candidates := candidatesSubtree, candidatesAlternate.

	^ candidates 
]
