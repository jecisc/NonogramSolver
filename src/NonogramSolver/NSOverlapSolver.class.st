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
	self flag: #todo.	"Use already filled items on the line. Use empty cases on the line."
	self
		withUnfinishedLinesDo: [ :lineIndex :clues | 
			| beginToEndInterval endToBeginInterval counter |
			beginToEndInterval := Array new: clues size.
			endToBeginInterval := Array new: clues size.

			counter := 1.
			clues
				doWithIndex: [ :clue :index | 
					beginToEndInterval at: index put: (counter to: counter + clue value - 1).
					counter := counter + clue value + 1 ].
			counter := self numberOfColumns.
			clues reverse
				doWithIndex: [ :clue :index | 
					endToBeginInterval at: clues size - index + 1 put: (counter - clue value + 1 to: counter).
					counter := counter - clue value - 1 ].

			counter := 1.
			beginToEndInterval
				with: endToBeginInterval
				do: [ :int1 :int2 | 
					| interval |
					interval := int1 intersection: int2.
					interval do: [ :index | self at: lineIndex at: index put: NSFilledState ].
					interval size = (clues at: counter) value ifTrue: [ (clues at: counter) solved ]. "if the interval matches the full clue, then the clue is solved."
					counter := counter + 1 ] ].

	self
		withUnfinishedColumnsDo: [ :columnIndex :clues | 
			| beginToEndInterval endToBeginInterval counter |
			beginToEndInterval := Array new: clues size.
			endToBeginInterval := Array new: clues size.

			counter := 1.
			clues
				doWithIndex: [ :clue :index | 
					beginToEndInterval at: index put: (counter to: counter + clue value - 1).
					counter := counter + clue value + 1 ].
			counter := self numberOfLines.
			clues reverse
				doWithIndex: [ :clue :index | 
					endToBeginInterval at: clues size - index + 1 put: (counter - clue value + 1 to: counter).
					counter := counter - clue value - 1 ].

			counter := 1.
			beginToEndInterval
				with: endToBeginInterval
				do: [ :int1 :int2 | 
					| interval |
					interval := int1 intersection: int2.
					interval do: [ :index | self at: index at: columnIndex put: NSFilledState ].
					interval size = (clues at: counter) value ifTrue: [ (clues at: counter) solved ]. "if the interval matches the full clue, then the clue is solved."
					counter := counter + 1 ]  ]
]
