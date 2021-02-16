Class {
	#name : #NSDirectOverlapDirection,
	#superclass : #NSAbstractOverlapDirection,
	#category : #NonogramSolver
}

{ #category : #'as yet unclassified' }
NSDirectOverlapDirection class >> shift: anIntegerOrInterval by: anInteger [
	^ anIntegerOrInterval + anInteger
]
