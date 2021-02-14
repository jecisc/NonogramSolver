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
			"	clues ifLineClues: [ (axisIndex = 15) ifTrue: [ 1halt. ] ] ifColumnClues: [  ]."
			"
		resolver grid lineAt: axisIndex.
		"
			| indexOfFirstNotEmptyCase indexOfFirstFilledCase firstUnresolvedClue indexOfCloseEmptyCase |
			self flag: #todo.	"do not stop at the first known but the first known and unresolved. Can check the first unsolved clue."
			"			firstUnresolvedClue := clues unresolvedClues first.
			(((firstUnresolvedClue possibleInterval min - firstUnresolvedClue value) max: 0) to: ((firstUnresolvedClue possibleInterval min - 1) max: 0)) select: [ :each |  ]
			1halt."
			indexOfFirstNotEmptyCase := 1.
			[ indexOfFirstNotEmptyCase > axisSize or: [ (clues inGridAt: indexOfFirstNotEmptyCase) isEmpty not ] ]
				whileFalse: [ indexOfFirstNotEmptyCase := indexOfFirstNotEmptyCase + 1 ].
			indexOfFirstFilledCase := 1.
			[ indexOfFirstFilledCase > axisSize or: [ (clues inGridAt: indexOfFirstFilledCase) isFilled ] ]
				whileFalse: [ indexOfFirstFilledCase := indexOfFirstFilledCase + 1 ].
			(indexOfFirstFilledCase < axisSize and: [ indexOfFirstNotEmptyCase + clues first value > indexOfFirstFilledCase ])
				ifTrue: [ indexOfFirstFilledCase to: indexOfFirstNotEmptyCase + clues first value - 1 do: [ :index | clues inGridAt: index put: NSFilledState ] ].


			self flag: #todo.	"do not stop at the first known but the first known and unresolved. Can check the first unsolved clue."
			indexOfFirstNotEmptyCase := axisSize.
			[ indexOfFirstNotEmptyCase < 1 or: [ (clues inGridAt: indexOfFirstNotEmptyCase) isEmpty not ] ]
				whileFalse: [ indexOfFirstNotEmptyCase := indexOfFirstNotEmptyCase - 1 ].
			indexOfFirstFilledCase := axisSize.
			[ indexOfFirstFilledCase < 1 or: [ (clues inGridAt: indexOfFirstFilledCase) isFilled ] ]
				whileFalse: [ indexOfFirstFilledCase := indexOfFirstFilledCase - 1 ].
			(indexOfFirstFilledCase > 1 and: [ indexOfFirstNotEmptyCase - clues last value < indexOfFirstFilledCase ])
				ifTrue: [ (indexOfFirstNotEmptyCase - clues last value + 1 to: indexOfFirstFilledCase) do: [ :index | clues inGridAt: index put: NSFilledState ] ] ]
]
