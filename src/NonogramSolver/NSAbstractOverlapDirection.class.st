Class {
	#name : #NSAbstractOverlapDirection,
	#superclass : #Object,
	#category : #NonogramSolver
}

{ #category : #testing }
NSAbstractOverlapDirection class >> isAbstract [ 
	^ self = NSAbstractOverlapDirection
]

{ #category : #'as yet unclassified' }
NSAbstractOverlapDirection class >> shift: anIntegerOrInterval by: anInteger [
	^ self subclassResponsibility
]
