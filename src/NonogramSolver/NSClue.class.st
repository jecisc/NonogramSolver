Class {
	#name : #NSClue,
	#superclass : #Object,
	#instVars : [
		'possibleIntervals',
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
NSClue >> addPossibleInterval: interval [
	self assert: interval min <= interval max.
	self assert: interval size >= value.
	self possibleIntervals add: interval
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
NSClue >> ban: anInterval [
	"Remove the interval as parameter from the possible interval."

	self isSolved ifTrue: [ ^ self ].

	self
		assert: (anInterval min < self possibleIntervals first min and: [ anInterval max > self possibleIntervals last max ]) not
		description: 'The interval should not include all possible intervals, else this mean the clue has no solution.'.

	"If the possible interval does not includes the interval in parameter, we do nothing."
	(self canIncludeAny: anInterval) ifFalse: [ ^ self ].

	(self possibleIntervals select: [ :interval | anInterval includesAny: interval ])
		do: [ :intervalToUpdate | 
			self possibleIntervals remove: intervalToUpdate.
			(anInterval includesAll: intervalToUpdate)
				ifFalse: [ intervalToUpdate min + value <= anInterval min ifTrue: [ self addPossibleInterval: (intervalToUpdate min to: anInterval min - 1) ].
					intervalToUpdate max - value >= anInterval max ifTrue: [ self addPossibleInterval: (anInterval max + 1 to: intervalToUpdate max) ] ] ].

	self checkIsSolved
]

{ #category : #testing }
NSClue >> canInclude: anIndex [
	^ self possibleIntervals anySatisfy: [ :int | int includes: anIndex]
]

{ #category : #testing }
NSClue >> canIncludeAll: aCollection [
	^ self possibleIntervals anySatisfy: [ :int | int includesAll: aCollection ]
]

{ #category : #testing }
NSClue >> canIncludeAny: aCollection [
	^ self possibleIntervals anySatisfy: [ :int | int includesAny: aCollection ]
]

{ #category : #checking }
NSClue >> check [
	self checkIsSolved
]

{ #category : #checking }
NSClue >> checkIsSolved [
	isSolved ifTrue: [ ^ true ].
	
	self possibleInterval size = value ifFalse: [ ^ false ].
	
	"If the clue is not solved but the possible interval is of the size of the value, we can mark it as solved and ensure the grid is filled."
	self solved.
	self possibleInterval do: [ :intervalIndex | self axis inGridAt: intervalIndex put: NSFilledState ].
		
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
	isSolved := false.
	possibleIntervals := SortedCollection sortUsing: #min ascending
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
	"Return the smallest interval containing all the possible intrevals of the clue."

	self possibleIntervals size = 1 ifTrue: [ ^ self possibleIntervals anyOne ].

	^ self possibleIntervals first min to: self possibleIntervals last max
]

{ #category : #accessing }
NSClue >> possibleIntervals [
	^ possibleIntervals
]

{ #category : #accessing }
NSClue >> possibleIntervals: aCollection [
	possibleIntervals removeAll.
	aCollection do: [ :interval | self addPossibleInterval: interval ]
]

{ #category : #printing }
NSClue >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' [';
		print: value;
		nextPutAll: ', '.
	self possibleIntervals size = 1
		ifTrue: [ aStream print: self possibleIntervals anyOne ]
		ifFalse: [ aStream nextPut: ${.
			self possibleIntervals do: [ :int | aStream print: int ] separatedBy: [ aStream nextPutAll: ' . ' ].
			aStream nextPut: $} ].
	aStream
		nextPutAll:
			(isSolved
				ifTrue: [ ', solved]' ]
				ifFalse: [ ', unsolved]' ])
]

{ #category : #accessing }
NSClue >> restrainTo: anInterval [
	self isSolved ifTrue: [ ^ self ].

	"Do not change the collection while iterating on it."
	(self possibleIntervals reject: [ :int | anInterval includesAll: int ])
		do: [ :intervalToUpdate | 
			self possibleIntervals remove: intervalToUpdate.
			(anInterval includesAny: intervalToUpdate)
				ifTrue: [ | newInterval |
					newInterval := (intervalToUpdate min max: anInterval min) to: (intervalToUpdate max min: anInterval max).
					newInterval size >= value ifTrue: [ self addPossibleInterval: newInterval ] ] ].

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
