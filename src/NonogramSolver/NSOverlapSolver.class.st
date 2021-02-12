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
NSOverlapSolver >> resolve [
	self
		withUnfinishedAxisDo: [ :axisIndex :clues :axisSize | 
			| endToBeginInterval counter beginToEndInterval |
			self flag: #todo.	"Use already filled items on the line. Use empty cases on the line."
			beginToEndInterval := Array new: clues size.
			endToBeginInterval := Array new: clues size.

			counter := 1.
			clues
				doWithIndex: [ :clue :index | 
					"skip the empty cases"
					[ (self axisAt: axisIndex at: counter for: clues) isEmpty ] whileTrue: [ counter := counter + 1 ].

					beginToEndInterval at: index put: (counter to: counter + clue value - 1).
					counter := counter + clue value + 1 ].

			counter := axisSize.
			clues reverse
				doWithIndex: [ :clue :index | 
					"skip the empty cases"
					[ (self axisAt: axisIndex at: counter for: clues) isEmpty ] whileTrue: [ counter := counter - 1 ].
					endToBeginInterval at: clues size - index + 1 put: (counter - clue value + 1 to: counter).
					counter := counter - clue value - 1 ].

			counter := 1.
			beginToEndInterval
				with: endToBeginInterval
				do: [ :int1 :int2 | 
					(clues at: counter) restrainPossibleIntervalWith: (int1 min to: int2 max).
					(int1 intersection: int2)
						do: [ :index | self axisAt: axisIndex at: index put: NSFilledState for: clues ].
					counter := counter + 1 ] ]
]
