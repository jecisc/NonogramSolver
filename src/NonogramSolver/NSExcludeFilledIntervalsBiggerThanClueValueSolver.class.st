Class {
	#name : #NSExcludeFilledIntervalsBiggerThanClueValueSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSExcludeFilledIntervalsBiggerThanClueValueSolver class >> priority [
	^ 100
]

{ #category : #resolving }
NSExcludeFilledIntervalsBiggerThanClueValueSolver >> resolveCurrentAxis [
	"If a filled interval is bigger than a matching clue, we can remove it and the cases surrounding it since we need at least one space between two intervals."

	self filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | (clue canIncludeAny: filledInterval) and: [ clue < filledInterval size ] ])
				ifNotEmpty: [ :matchingClues | matchingClues do: [ :clue | clue ban: (filledInterval min - 1 to: filledInterval max + 1) ] ] ]
]
