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
NSClue >> banFromPossibleInterval: anInterval [
	"Remove the interval as parameter from the possible interval."

	self isSolved ifTrue: [ ^ self ].

	"If the possible interval does not includes the interval in parameter, we do nothing."
	(self canIncludeAny: anInterval) ifFalse: [ ^ self ].

	(anInterval min > possibleInterval min and: [ anInterval max < possibleInterval max ])
		ifTrue: [ self flag: #todo. "The interval should not be included inside the possible interval. This would split the possible interval in two. Maybe later I could manage possible intervalS but not now." ^ self ].

	(anInterval min < possibleInterval min and: [ anInterval max > possibleInterval max ])
		ifTrue: [ self error: 'The interval should not include the possible interval, else this mean the clue has no solution.' ].

	"Remove all elements found in the interval and recast the collection as an interval."
	possibleInterval := possibleInterval asOrderedCollection.
	possibleInterval removeAllFoundIn: anInterval.
	self possibleInterval: (possibleInterval min to: possibleInterval max).

	self checkIsSolved
]

{ #category : #testing }
NSClue >> canInclude: anIndex [
	^ possibleInterval includes: anIndex
]

{ #category : #testing }
NSClue >> canIncludeAll: aCollection [
	^ possibleInterval includesAll: aCollection
]

{ #category : #testing }
NSClue >> canIncludeAny: aCollection [
	^ possibleInterval includesAny: aCollection
]

{ #category : #checking }
NSClue >> check [
	self checkIsSolved
]

{ #category : #checking }
NSClue >> checkIsSolved [
	isSolved ifTrue: [ ^ true ].
	
	possibleInterval size = value ifFalse: [ ^ false ].
	
	"If the clue is not solved but the possible interval is of the size of the value, we can mark it as solved and ensure the grid is filled."
	self solved.
	possibleInterval do: [ :intervalIndex | self axis inGridAt: intervalIndex put: NSFilledState ].
		
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
	self assert: anObject min <= anObject max.
	self assert: anObject size >= value.
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
	self isSolved ifTrue: [ ^ self ].

	self possibleInterval: (((possibleInterval min) max: anInterval min) to: ((possibleInterval max) min: anInterval max)).
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
