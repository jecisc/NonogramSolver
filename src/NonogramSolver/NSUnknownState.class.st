Class {
	#name : #NSUnknownState,
	#superclass : #NSAbstractCaseState,
	#category : #'NonogramSolver-Model'
}

{ #category : #testing }
NSUnknownState class >> isKnown [
	^ false
]

{ #category : #printing }
NSUnknownState class >> printOn: aStream [
	aStream nextPut: $_
]
