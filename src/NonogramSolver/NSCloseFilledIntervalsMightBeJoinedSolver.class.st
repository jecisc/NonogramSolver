Class {
	#name : #NSCloseFilledIntervalsMightBeJoinedSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSCloseFilledIntervalsMightBeJoinedSolver class >> priority [
	^ 160
]

{ #category : #resolving }
NSCloseFilledIntervalsMightBeJoinedSolver >> resolveCurrentAxis [
	"1 2 1 | | | |o| |o| | | | | | |
	can be:
	1 2 1 | | | |o|x|o| | | | | | |"

	self  filledIntervals
		overlappingPairsDo: [ :filledInterval1 :filledInterval2 | 
			filledInterval2 min - filledInterval1 max = 2
				ifTrue: [ ((self unresolvedClues select: [ :clue | (clue canIncludeAll: filledInterval1) and: [ clue canIncludeAll: filledInterval2 ] ])
						ifEmpty: [ true ]
						ifNotEmpty: [ :matchingClues | (filledInterval1 min to: filledInterval2 max) size > matchingClues max ])
						ifTrue: [ self at: filledInterval1 max + 1 put: NSEmptyState ] ] ]
]
