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
	self flag: #todo. "Use already filled items on the line. Use empty cases on the line."
	self withUnfinishedLinesDo: [ :lineIndex :lineClue |
		| beginToEndInterval endToBeginInterval counter |
		beginToEndInterval := Array new: lineClue size.
		endToBeginInterval := Array new: lineClue size.
		
		counter := 1.
		lineClue doWithIndex: [ :clue :index | beginToEndInterval at: index put: (counter to: counter + clue - 1). counter := counter + clue + 1 ].
		counter := self numberOfColumns.
		lineClue reverse doWithIndex: [ :clue :index | endToBeginInterval at: lineClue size - index + 1 put: (counter - clue + 1 to: counter). counter := counter - clue - 1 ].
		
		beginToEndInterval with: endToBeginInterval do: [ :int1 :int2 | (int1 intersection: int2) do: [ :index | self at: lineIndex at: index put: NSFilledState ]  ]. ].

	self withUnfinishedColumnsDo: [ :columnIndex :columnClue | | beginToEndInterval endToBeginInterval counter |
		beginToEndInterval := Array new: columnClue size.
		endToBeginInterval := Array new: columnClue size.
		
		counter := 1.
		columnClue doWithIndex: [ :clue :index | beginToEndInterval at: index put: (counter to: counter + clue - 1). counter := counter + clue + 1 ].
		counter := self numberOfLines.
		columnClue reverse doWithIndex: [ :clue :index | endToBeginInterval at: columnClue size - index + 1 put: (counter - clue + 1 to: counter). counter := counter - clue - 1 ].

		beginToEndInterval with: endToBeginInterval do: [ :int1 :int2 | (int1 intersection: int2) do: [ :index | self at: index at: columnIndex put: NSFilledState ]  ]. ].
]
