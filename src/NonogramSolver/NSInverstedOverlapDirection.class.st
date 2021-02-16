Class {
	#name : #NSInverstedOverlapDirection,
	#superclass : #NSAbstractOverlapDirection,
	#category : #NonogramSolver
}

{ #category : #'as yet unclassified' }
NSInverstedOverlapDirection class >> shift: anIntegerOrInterval by: anInteger [
	^ anIntegerOrInterval - anInteger
]
