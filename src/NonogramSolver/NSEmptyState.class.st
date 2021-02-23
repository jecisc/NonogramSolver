Class {
	#name : #NSEmptyState,
	#superclass : #NSAbstractCaseState,
	#category : #'NonogramSolver-Model'
}

{ #category : #testing }
NSEmptyState class >> isEmpty [
	^ true
]

{ #category : #printing }
NSEmptyState class >> printOn: aStream [
	aStream nextPut: $x
]
