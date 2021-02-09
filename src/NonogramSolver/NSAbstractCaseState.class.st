Class {
	#name : #NSAbstractCaseState,
	#superclass : #Object,
	#category : #NonogramSolver
}

{ #category : #testing }
NSAbstractCaseState class >> isEmpty [
	^ false
]

{ #category : #testing }
NSAbstractCaseState class >> isFilled [
	^ false
]

{ #category : #testing }
NSAbstractCaseState class >> isKnown [
	^ true
]
