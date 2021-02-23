Class {
	#name : #NSPushBorderSolver,
	#superclass : #NSAbstractSolver,
	#instVars : [
		'fromBegining'
	],
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSPushBorderSolver class >> priority [
	^ 30
]

{ #category : #resolving }
NSPushBorderSolver >> resolveCurrentAxis [
	self unresolvedClues
		do: [ :clue | 
			| possibleInterval |
			possibleInterval := clue possibleIntervals first.
			(((possibleInterval min - clue max: 0) to: (possibleInterval min - 1 max: 0)) select: [ :index | index = 0 or: [ (self at: index) isEmpty ] ])
				ifNotEmpty: [ :emptyCases | 
					| indexOfCloseEmptyCase |
					indexOfCloseEmptyCase := emptyCases max.
					possibleInterval
						detect: [ :index | (clues select: [ :c | c canInclude: index ]) size = 1 and: [ (self at: index) isFilled ] ]
						ifFound:
							[ :indexOfFirstFilledCaseSpecificToClue | indexOfFirstFilledCaseSpecificToClue + 1 to: indexOfCloseEmptyCase + clue do: [ :index | self at: index put: NSFilledState ] ] ].

			possibleInterval := clue possibleIntervals last.
			(((possibleInterval max + clue min: axisSize + 1) to: (possibleInterval max + 1 min: axisSize + 1))
				select: [ :index | index = (axisSize + 1) or: [ (self at: index) isEmpty ] ])
				ifNotEmpty: [ :emptyCases | 
					| indexOfCloseEmptyCase |
					indexOfCloseEmptyCase := emptyCases min.
					possibleInterval reversed
						detect: [ :index | (clues select: [ :c | c canInclude: index ]) size = 1 and: [ (self at: index) isFilled ] ]
						ifFound:
							[ :indexOfFirstFilledCaseSpecificToClue | indexOfCloseEmptyCase - clue to: indexOfFirstFilledCaseSpecificToClue - 1 do: [ :index | self at: index put: NSFilledState ] ] ] ]
]
