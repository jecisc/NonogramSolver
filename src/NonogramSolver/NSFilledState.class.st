Class {
	#name : #NSFilledState,
	#superclass : #NSAbstractCaseState,
	#category : #NonogramSolver
}

{ #category : #testing }
NSFilledState class >> isFilled [
	^ true
]

{ #category : #printing }
NSFilledState class >> printOn: aStream [
	aStream nextPut: $o
]
