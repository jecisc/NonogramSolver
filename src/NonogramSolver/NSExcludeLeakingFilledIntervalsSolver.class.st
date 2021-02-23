Class {
	#name : #NSExcludeLeakingFilledIntervalsSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSExcludeLeakingFilledIntervalsSolver class >> priority [
	^ 80
]

{ #category : #resolving }
NSExcludeLeakingFilledIntervalsSolver >> resolveCurrentAxis [
	"If a filled interval is only partly in a clue, we can remove it and the cases surrounding it since we need at least one space between two intervals."

	self filledIntervals
		do: [ :filledInterval | 
			(clues unresolvedClues select: [ :clue | (clue canIncludeAny: filledInterval) and: [ (clue canIncludeAll: filledInterval) not ] ])
				ifNotEmpty: [ :matchingClues | matchingClues do: [ :clue | clue ban: (filledInterval min - 1 to: filledInterval max + 1) ] ] ]
]
