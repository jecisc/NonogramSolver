Class {
	#name : #NSClue,
	#superclass : #Object,
	#instVars : [
		'possibleInterval',
		'isSolved',
		'value',
		'axis'
	],
	#category : #NonogramSolver
}

{ #category : #'instance creation' }
NSClue class >> clue: anInteger [
	^ self new
		value: anInteger;
		yourself
]

{ #category : #'instance creation' }
NSClue class >> clue: anInteger axis: anAxis [
	^ self new
		value: anInteger;
		axis: anAxis;
		yourself
]

{ #category : #accessing }
NSClue >> axis [
	^ axis
]

{ #category : #accessing }
NSClue >> axis: anObject [
	axis := anObject
]

{ #category : #initialization }
NSClue >> initialize [
	super initialize.
	isSolved := false
]

{ #category : #accessing }
NSClue >> isSolved [
	^ isSolved
]

{ #category : #accessing }
NSClue >> isSolved: anObject [
	isSolved := anObject
]

{ #category : #accessing }
NSClue >> possibleInterval [
	^ possibleInterval
]

{ #category : #accessing }
NSClue >> possibleInterval: anObject [
	possibleInterval := anObject
]

{ #category : #printing }
NSClue >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' [';
		print: value;
		nextPutAll: ', ';
		print: possibleInterval;
		nextPutAll:
			(isSolved
				ifTrue: [ ', solved]' ]
				ifFalse: [ ', unsolved]' ])
]

{ #category : #accessing }
NSClue >> solved [
	isSolved := true
]

{ #category : #accessing }
NSClue >> value [
	^ value
]

{ #category : #accessing }
NSClue >> value: anObject [
	value := anObject
]
