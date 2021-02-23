Class {
	#name : #NSFilledState,
	#superclass : #NSAbstractCaseState,
	#category : #'NonogramSolver-Model'
}

{ #category : #testing }
NSFilledState class >> isFilled [
	^ true
]

{ #category : #printing }
NSFilledState class >> printOn: aStream [
	aStream nextPut: $o
]
