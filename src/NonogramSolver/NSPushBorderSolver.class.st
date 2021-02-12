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
		withUnfinishedAxisDo: [ :axisIndex :clues :axisSize | 
			"	clues ifLineClues: [ (axisIndex = 15) ifTrue: [ 1halt. ] ] ifColumnClues: [  ]."
			"
		resolver grid lineAt: axisIndex.
		"
			| indexOfFirstNotEmptyCase indexOfFirstFilledCase |
			self flag: #todo.	"do not stop at the first known but the first known and unresolved. Can check the first unsolved clue."
			indexOfFirstNotEmptyCase := 1.
			[ indexOfFirstNotEmptyCase > axisSize or: [ (self axisAt: axisIndex at: indexOfFirstNotEmptyCase for: clues) isEmpty not ] ]
				whileFalse: [ indexOfFirstNotEmptyCase := indexOfFirstNotEmptyCase + 1 ].
			indexOfFirstFilledCase := 1.
			[ indexOfFirstFilledCase > axisSize or: [ (self axisAt: axisIndex at: indexOfFirstFilledCase for: clues) isFilled ] ]
				whileFalse: [ indexOfFirstFilledCase := indexOfFirstFilledCase + 1 ].
			(indexOfFirstFilledCase < axisSize and: [ indexOfFirstNotEmptyCase + clues first value > indexOfFirstFilledCase ])
				ifTrue: [ indexOfFirstFilledCase to: indexOfFirstNotEmptyCase + clues first value - 1 do: [ :index | 
						self
							axisAt: axisIndex
							at: index
							put: NSFilledState
							for: clues ] ].


			self flag: #todo.	"do not stop at the first known but the first known and unresolved. Can check the first unsolved clue."
			indexOfFirstNotEmptyCase := axisSize.
			[ indexOfFirstNotEmptyCase < 1 or: [ (self axisAt: axisIndex at: indexOfFirstNotEmptyCase for: clues) isEmpty not ] ]
				whileFalse: [ indexOfFirstNotEmptyCase := indexOfFirstNotEmptyCase - 1 ].
			indexOfFirstFilledCase := axisSize.
			[ indexOfFirstFilledCase < 1 or: [ (self axisAt: axisIndex at: indexOfFirstFilledCase for: clues) isFilled ] ]
				whileFalse: [ indexOfFirstFilledCase := indexOfFirstFilledCase - 1 ].
			(indexOfFirstFilledCase > 1 and: [ indexOfFirstNotEmptyCase - clues last value < indexOfFirstFilledCase ])
				ifTrue: [ (indexOfFirstNotEmptyCase - clues last value + 1 to: indexOfFirstFilledCase)
						do: [ :index | 
							self
								axisAt: axisIndex
								at: index
								put: NSFilledState
								for: clues ] ] ]
]
