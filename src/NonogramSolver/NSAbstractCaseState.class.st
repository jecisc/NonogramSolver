Class {
	#name : #NSAbstractCaseState,
	#superclass : #Object,
	#category : #'NonogramSolver-Model'
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
