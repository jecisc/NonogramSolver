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
NSOverlapSolver >> lookForOverlapForClues: clues axisSize: axisSize currentIndex: axisIndex [
	| endToBeginInterval counter beginToEndInterval |
	self flag: #todo.	"Use already filled items on the line. Use empty cases on the line."
	beginToEndInterval := Array new: clues size.
	endToBeginInterval := Array new: clues size.

	counter := 1.
	clues
		doWithIndex: [ :clue :index | 
			beginToEndInterval at: index put: (counter to: counter + clue value - 1).
			counter := counter + clue value + 1 ].
	counter := axisSize.
	clues reverse
		doWithIndex: [ :clue :index | 
			endToBeginInterval at: clues size - index + 1 put: (counter - clue value + 1 to: counter).
			counter := counter - clue value - 1 ].

	counter := 1.
	beginToEndInterval
		with: endToBeginInterval
		do: [ :int1 :int2 | 
			(clues at: counter) restrainPossibleIntervalWith: (int1 min to: int2 max).
			(int1 intersection: int2) do: [ :index | clues ifLineClues: [ self at: axisIndex at: index put: NSFilledState ] ifColumnClues: [ self at: index at: axisIndex put: NSFilledState ] ].
			counter := counter + 1 ]
]

{ #category : #resolving }
NSOverlapSolver >> resolve [
	self withUnfinishedLinesDo: [ :lineIndex :clues :axisSize | self lookForOverlapForClues: clues axisSize: axisSize currentIndex: lineIndex ].
	self withUnfinishedColumnsDo: [ :columnIndex :clues :axisSize | self lookForOverlapForClues: clues axisSize: axisSize currentIndex: columnIndex ]
]
