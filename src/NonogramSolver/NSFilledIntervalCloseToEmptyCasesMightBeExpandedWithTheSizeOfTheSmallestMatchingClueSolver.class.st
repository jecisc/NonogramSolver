Class {
	#name : #NSFilledIntervalCloseToEmptyCasesMightBeExpandedWithTheSizeOfTheSmallestMatchingClueSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSFilledIntervalCloseToEmptyCasesMightBeExpandedWithTheSizeOfTheSmallestMatchingClueSolver class >> priority [
	^ 140
]

{ #category : #resolving }
NSFilledIntervalCloseToEmptyCasesMightBeExpandedWithTheSizeOfTheSmallestMatchingClueSolver >> resolveCurrentAxis [
	"For example if we have:
	| | |x|x| | |o|o|o| | | | | | |
	And the filled interval can be associated to a clue of size 7 and another of size 9, then we can fill like this:
	| | |x|x| | |o|o|o|o|o| | | | |"

	"Add also the borders of the axis."

	emptyIntervals := self emptyIntervals
		addFirst: (0 to: 0);
		addLast: (axisSize + 1 to: axisSize + 1);
		yourself.

	self filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					emptyIntervals
						detect: [ :interval | interval includesAny: (filledInterval max to: filledInterval min + matchingClues min) ]
						ifFound: [ :emptyInterval | emptyInterval min - matchingClues min to: filledInterval min - 1 do: [ :index | self at: index put: NSFilledState ] ].

					emptyIntervals
						detect: [ :interval | interval includesAny: (filledInterval max - matchingClues min to: filledInterval max) ]
						ifFound: [ :emptyInterval | filledInterval max + 1 to: emptyInterval max + matchingClues min do: [ :index | self at: index put: NSFilledState ] ] ] ]
]
