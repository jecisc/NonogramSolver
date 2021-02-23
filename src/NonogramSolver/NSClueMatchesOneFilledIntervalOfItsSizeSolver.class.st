Class {
	#name : #NSClueMatchesOneFilledIntervalOfItsSizeSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSClueMatchesOneFilledIntervalOfItsSizeSolver class >> priority [
	^ 50
]

{ #category : #resolving }
NSClueMatchesOneFilledIntervalOfItsSizeSolver >> resolveCurrentAxis [
	"If a filled interval matches only one clue and is the same size as this clue, then we can resolve the clue."

	self filledIntervals
		do: [ :filledInterval | 
			(clues unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ])
				ifNotEmpty:
					[ :matchingClues | (matchingClues size = 1 and: [ matchingClues anyOne value = filledInterval size ]) ifTrue: [ matchingClues anyOne restrainTo: filledInterval ] ] ]
]
