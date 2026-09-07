Class {
	#name : 'UmeSimplifyGrammarBoth',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Shin-Shrinkers',
	#package : 'Shin',
	#tag : 'Shrinkers'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> reduce: subtree using: grammar matching: symbol depth: depth [ 
    
   | candidatesSubtree candidatesAlternate candidates|
    
   candidates := OrderedCollection new.
   candidatesAlternate := UmeSimplifyGrammarAlternateReduction alternateReduction: subtree using: grammar matchingWith: symbol depth: depth .

	candidatesSubtree := UmeSimplifyGrammarSubtreeReducer findSubtree: subtree mathchingWith: symbol depth: depth.
	candidates := candidatesSubtree, candidatesAlternate.

	^ candidates 
]
