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

{ #category : #checking }
NSClue >> checkIsSolved [
	isSolved ifTrue: [ ^ true ].
	
	possibleInterval size = value ifFalse: [ ^ false ].
	
	self solved.
	possibleInterval do: [ :intervalIndex | 
		self
			ifLineClue: [ self grid at: self index at: intervalIndex put: NSFilledState ]
			ifColumnClue: [ self grid at: intervalIndex at: self index put: NSFilledState ] ].
]

{ #category : #accessing }
NSClue >> grid [
	^ axis grid
]

{ #category : #testing }
NSClue >> ifLineClue: aBlockClosure ifColumnClue: aBlockClosure2 [ 
	^ axis ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 
]

{ #category : #accessing }
NSClue >> index [
	^ axis indexOf: self
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
NSClue >> restrainPossibleIntervalWith: anInterval [ 
	possibleInterval := ((possibleInterval min) max: anInterval min) to: ((possibleInterval max) min: anInterval max).
	self checkIsSolved
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
