Class {
	#name : #NSFilledIntervalsCanReducePossibleIntervalsSizeSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSFilledIntervalsCanReducePossibleIntervalsSizeSolver class >> priority [
	^ 150
]

{ #category : #resolving }
NSFilledIntervalsCanReducePossibleIntervalsSizeSolver >> resolveCurrentAxis [
	"For example if we have a clue whose possible interval is:
	
	| | |o|o| | | |
	
	And its size is 3, then we can ban the first case because if the clue was there, then we fill more cases than required."

	self filledIntervals
		do: [ :filledInterval | 
			self unresolvedClues
				do: [ :clue | 
					clue possibleIntervals
						detect: [ :interval | interval includesAny: filledInterval ]
						ifFound: [ :possibleInterval | 
							(possibleInterval min to: filledInterval max) size > clue
								ifTrue: [ ((possibleInterval min to: possibleInterval min + clue) intersection: filledInterval)
										ifNotEmpty: [ clue ban: (possibleInterval min to: filledInterval max - clue) ] ].
							(filledInterval min to: possibleInterval max) size > clue
								ifTrue: [ ((possibleInterval max - clue to: possibleInterval max) intersection: filledInterval)
										ifNotEmpty: [ clue ban: (filledInterval min + clue to: possibleInterval max) ] ] ] ] ]
]
