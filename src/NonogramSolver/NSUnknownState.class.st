Class {
	#name : #NSUnknownState,
	#superclass : #NSAbstractCaseState,
	#category : #NonogramSolver
}

{ #category : #testing }
NSUnknownState class >> isKnown [
	^ false
]

{ #category : #printing }
NSUnknownState class >> printOn: aStream [
	aStream nextPut: $_
]
