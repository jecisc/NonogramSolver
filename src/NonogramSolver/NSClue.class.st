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

{ #category : #accessing }
NSClue >> axisIndex [
	^ axis index
]

{ #category : #accessing }
NSClue >> banFromPossibleInterval: anInterval [
	"Remove the interval as parameter from the possible interval."

	"If the possible interval does not includes the interval in parameter, we do nothing."
	(possibleInterval includesAny: anInterval) ifFalse: [ ^ self ].

	(anInterval min > possibleInterval min and: [ anInterval max < possibleInterval max ])
		ifTrue: [ self error: 'The interval should not be included inside the possible interval. This would split the possible interval in two.' ].

	(anInterval min < possibleInterval min and: [ anInterval max > possibleInterval max ])
		ifTrue: [ self error: 'The interval should not include the possible interval, else this mean the clue has no solution.' ].

	"Remove all elements found in the interval and recast the collection as an interval."
	possibleInterval := possibleInterval asOrderedCollection.
	possibleInterval removeAllFoundIn: anInterval.
	possibleInterval := possibleInterval min to: possibleInterval max.

	self checkIsSolved
]

{ #category : #checking }
NSClue >> checkIsSolved [
	isSolved ifTrue: [ ^ true ].
	
	possibleInterval size = value ifFalse: [ ^ false ].
	
	"If the clue is not solved but the possible interval is of the size of the value, we can mark it as solved and ensure the grid is filled."
	self solved.
	possibleInterval do: [ :intervalIndex | 
		self
			ifLineClue: [ self grid at: self axisIndex at: intervalIndex put: NSFilledState ]
			ifColumnClue: [ self grid at: intervalIndex at: self axisIndex put: NSFilledState ] ].
		
	^ true
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
	isSolved := true.
	axis banIntervalOf: self
]

{ #category : #accessing }
NSClue >> value [
	^ value
]

{ #category : #accessing }
NSClue >> value: anObject [
	value := anObject
]
