Class {
	#name : #NSAbstractClues,
	#superclass : #Object,
	#instVars : [
		'clues'
	],
	#category : #NonogramSolver
}

{ #category : #'instance creation' }
NSAbstractClues class >> buildFrom: aXMLElement [ 
	^ self new
		buildFrom: aXMLElement;
		yourself
]

{ #category : #accessing }
NSAbstractClues >> at: anInteger [
	^ clues at: anInteger
]

{ #category : #accessing }
NSAbstractClues >> buildFrom: arg1 [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
NSAbstractClues >> size [
	^ clues size
]
