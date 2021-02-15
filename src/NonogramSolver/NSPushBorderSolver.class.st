Class {
	#name : #NSPushBorderSolver,
	#superclass : #NSAbstractSolver,
	#instVars : [
		'fromBegining'
	],
	#category : #NonogramSolver
}

{ #category : #accessing }
NSPushBorderSolver class >> priority [
	^ 30
]

{ #category : #resolving }
NSPushBorderSolver >> resolve [
	self
		withUnfinishedAxisDo: [ :clues :axisSize | 
				"clues ifLineClues: [ (clues index = 3) ifTrue: [ 1halt. ] ] ifColumnClues: [  ]."
			"
		clues gridAxis
		"
			clues unresolvedClues
				do: [ :clue | 
					(((clue deprecatedPossibleInterval min - clue value max: 0) to: (clue deprecatedPossibleInterval min - 1 max: 0))
						select: [ :index | index = 0 or: [ (clues inGridAt: index) isEmpty ] ])
						ifNotEmpty: [ :emptyCases | 
							| indexOfCloseEmptyCase |
							indexOfCloseEmptyCase := emptyCases max.
							clue deprecatedPossibleInterval
								detect: [ :index | (clues select: [ :c | c canInclude: index ]) size = 1 and: [ (clues inGridAt: index) isFilled ] ]
								ifFound:
									[ :indexOfFirstFilledCaseSpecificToClue | indexOfFirstFilledCaseSpecificToClue + 1 to: indexOfCloseEmptyCase + clue value do: [ :index | clues inGridAt: index put: NSFilledState ] ] ].

					(((clue deprecatedPossibleInterval max + clue value min: axisSize + 1) to: (clue deprecatedPossibleInterval max + 1 min: axisSize + 1))
						select: [ :index | index = (axisSize + 1) or: [ (clues inGridAt: index) isEmpty ] ])
						ifNotEmpty: [ :emptyCases | 
							| indexOfCloseEmptyCase |
							indexOfCloseEmptyCase := emptyCases min.
							clue deprecatedPossibleInterval reversed
								detect: [ :index | (clues select: [ :c | c canInclude: index ]) size = 1 and: [ (clues inGridAt: index) isFilled ] ]
								ifFound:
									[ :indexOfFirstFilledCaseSpecificToClue | indexOfCloseEmptyCase - clue value to: indexOfFirstFilledCaseSpecificToClue - 1 do: [ :index | clues inGridAt: index put: NSFilledState ] ] ] ] ]
]
