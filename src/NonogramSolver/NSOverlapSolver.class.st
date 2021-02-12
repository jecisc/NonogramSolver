Class {
	#name : #NSOverlapSolver,
	#superclass : #NSAbstractSolver,
	#category : #NonogramSolver
}

{ #category : #accessing }
NSOverlapSolver class >> priority [
	^ 20
]

{ #category : #resolving }
NSOverlapSolver >> reduceInterval: possibleInterval forClue: clue axisIndex: axisIndex clues: clues [
	"We check if we have an empty case at the beginning or end of the possible interval that would make the clue impossible to fit."

	| initialInterval reducedInterval |
	initialInterval := possibleInterval.
	[ reducedInterval := self
		reduceOnceInterval: initialInterval
		forClue: clue
		axisIndex: axisIndex
		clues: clues.
	initialInterval = reducedInterval ] whileFalse: [ initialInterval := reducedInterval ].	"As long as we can reduce, we try to reduce once again."
	^ reducedInterval
]

{ #category : #resolving }
NSOverlapSolver >> reduceOnceInterval: initialInterval forClue: clue axisIndex: axisIndex clues: clues [
	| reducedInterval |
	reducedInterval := initialInterval.

	((reducedInterval min to: (reducedInterval min + clue value min: reducedInterval max)) select: [ :i | (self axisAt: axisIndex at: i for: clues) isEmpty ])
		ifNotEmpty: [ :emptyCases | reducedInterval := emptyCases max to: reducedInterval max ].

	(((reducedInterval max - clue value max: reducedInterval min) to: reducedInterval max) select: [ :i | (self axisAt: axisIndex at: i for: clues) isEmpty ])
		ifNotEmpty: [ :emptyCases | reducedInterval := reducedInterval min to: emptyCases min ].

	^ reducedInterval
]

{ #category : #resolving }
NSOverlapSolver >> resolve [
	self
		withUnfinishedAxisDo: [ :axisIndex :clues :axisSize | 
			| endToBeginInterval counter beginToEndInterval |
			self flag: #todo.	"Use already filled items on the line. Use empty cases on the line."
			beginToEndInterval := Array new: clues size.
			endToBeginInterval := Array new: clues size.

			self flag: #todo.	"We might be able to remove the duplication?"
			counter := 1.
			clues
				doWithIndex: [ :clue :index | 
					beginToEndInterval at: index put: (self reduceInterval: (counter to: counter + clue value - 1) forClue: clue axisIndex: axisIndex clues: clues).
					counter := counter + clue value + 1 ].

			counter := axisSize.
			clues reverse
				doWithIndex: [ :clue :index |
					endToBeginInterval at: clues size - index + 1 put: (self reduceInterval: (counter - clue value + 1 to: counter) forClue: clue axisIndex: axisIndex clues: clues).
					counter := counter - clue value - 1 ].

			counter := 1.
			beginToEndInterval
				with: endToBeginInterval
				do: [ :int1 :int2 | 
					(clues at: counter) restrainPossibleIntervalWith: (int1 min to: int2 max).
					(int1 intersection: int2)
						do: [ :index | 
							self
								axisAt: axisIndex
								at: index
								put: NSFilledState
								for: clues ].
					counter := counter + 1 ] ]
]
