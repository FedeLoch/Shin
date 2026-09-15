Class {
	#name : 'AritExpressionGrammar',
	#superclass : 'GncGrammar',
	#instVars : [
		'ntStart',
		'ntExpr',
		'ntTerm',
		'ntOp',
		'ntFactor',
		'ntInt',
		'ntDigit'
	],
	#category : 'Shin-Parsing',
	#package : 'Shin',
	#tag : 'Parsing'
}

{ #category : 'initialization' }
AritExpressionGrammar >> defineGrammar [

    ntStart --> ntExpr.
    
    ntExpr --> ntTerm | ntTerm, ntOp, ntExpr.
    
    ntTerm --> ntFactor.
    
    ntFactor --> ntInt | '(', ntExpr, ')'.
    
    ntInt --> ntDigit | ntDigit, ntInt.
    
    ntDigit --> ($0 - $9).
    
    ntOp --> '+' | '*' | '/' | '-'.
    
    ^ ntStart 
]
