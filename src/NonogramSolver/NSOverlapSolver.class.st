Class {
	#name : #NSOverlapSolver,
	#superclass : #NSAbstractSolver,
	#instVars : [
		'counter'
	],
	#category : #NonogramSolver
}

{ #category : #accessing }
NSOverlapSolver class >> priority [
	^ 20
]

{ #category : #resolving }
NSOverlapSolver >> resolve [
	self
		withUnfinishedAxisDo: [ :clues :axisSize | 
			| endToBeginInterval beginToEndInterval |
			self flag: #todo.	"Use already filled items on the line. Use empty cases on the line."
			beginToEndInterval := Array new: clues size.
			endToBeginInterval := Array new: clues size.

			counter := 1.
			clues
				doWithIndex: [ :clue :index | 
					beginToEndInterval
						at: index
						put:
							(self
								tryToShiftInterval: (counter to: counter + clue value - 1)
								clueValue: clue value
								forClues: clues
								shiftFurther: true).
					counter := counter + clue value + 1 ].

			counter := axisSize.
			clues reverse
				doWithIndex: [ :clue :index | 
					endToBeginInterval
						at: clues size - index + 1
						put:
							(self
								tryToShiftInterval: (counter - clue value + 1 to: counter)
								clueValue: clue value
								forClues: clues
								shiftFurther: false).
					counter := counter - clue value - 1 ].

			counter := 1.
			beginToEndInterval
				with: endToBeginInterval
				do: [ :int1 :int2 | 
					(clues at: counter) restrainPossibleIntervalWith: (int1 min to: int2 max).
					(int1 intersection: int2) do: [ :index | clues inGridAt: index put: NSFilledState ].
					counter := counter + 1 ] ]
]

{ #category : #resolving }
NSOverlapSolver >> tryToShiftInterval: possibleInterval clueValue: clueValue forClues: clues shiftFurther: aBoolean [
	| initialInterval shiftedInterval |
	initialInterval := possibleInterval.
	[ shiftedInterval := self
		tryToShiftOnceInterval: initialInterval
		clueValue: clueValue
		forClues: clues
		shiftFurther: aBoolean.
	initialInterval = shiftedInterval ] whileFalse: [ initialInterval := shiftedInterval ].	"As long as we can shift, we try to shift once again."
	^ shiftedInterval
]

{ #category : #resolving }
NSOverlapSolver >> tryToShiftOnceInterval: possibleInterval clueValue: clueValue forClues: clues shiftFurther: aBoolean [
	| interval |
	interval := possibleInterval.
	(interval select: [ :i | (clues inGridAt: i) isEmpty ])
		ifNotEmpty: [ :emptyCases | 
			| shift |
			shift := aBoolean
				ifTrue: [ emptyCases max - interval min + 1 ]
				ifFalse: [ interval max - emptyCases min + 1 ].
			counter := aBoolean
				ifTrue: [ counter + shift ]
				ifFalse: [ counter - shift ].
			interval := aBoolean
				ifTrue: [ interval + shift ]
				ifFalse: [ interval - shift ] ].
	^ interval
]
