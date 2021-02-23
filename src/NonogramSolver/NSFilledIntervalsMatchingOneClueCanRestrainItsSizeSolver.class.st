Class {
	#name : #NSFilledIntervalsMatchingOneClueCanRestrainItsSizeSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSFilledIntervalsMatchingOneClueCanRestrainItsSizeSolver class >> priority [
	^ 110
]

{ #category : #resolving }
NSFilledIntervalsMatchingOneClueCanRestrainItsSizeSolver >> resolveCurrentAxis [
	"If a filled interval is in a clue, then we can restrain the possibleIntervals of the clue to remove cases too far from this interval.
	
	Implementation detail:
		we can use #canIncludeAny: instead of #canIncludeAll: because this check is called after NSExcludeFilledIntervalsBiggerThanClueValueSolver"

	self filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAny: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					matchingClues size = 1
						ifTrue: [ | clue |
							clue := matchingClues anyOne.
							clue restrainTo: (filledInterval max - clue + 1 to: filledInterval min + clue - 1) ] ] ]
]
