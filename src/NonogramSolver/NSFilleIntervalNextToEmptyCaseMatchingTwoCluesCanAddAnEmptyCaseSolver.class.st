Class {
	#name : #NSFilleIntervalNextToEmptyCaseMatchingTwoCluesCanAddAnEmptyCaseSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSFilleIntervalNextToEmptyCaseMatchingTwoCluesCanAddAnEmptyCaseSolver class >> priority [
	^ 180
]

{ #category : #resolving }
NSFilleIntervalNextToEmptyCaseMatchingTwoCluesCanAddAnEmptyCaseSolver >> resolveCurrentAxis [
	| emptyCases |
	"Add also the borders of the axis."
	emptyCases := self emptyIntervals flattened asOrderedCollection
		addFirst: 0;
		addLast: axisSize + 1;
		yourself.
	self filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					matchingClues size = 2
						ifTrue: [ ((emptyCases includes: filledInterval min - 1)
								and: [ (emptyCases includes: filledInterval max + 1) not
										and: [ matchingClues first >= matchingClues second
												and: [ matchingClues includesAll: (clues select: [ :clue | clue canInclude: filledInterval min + matchingClues max ]) ] ] ])
								ifTrue: [ self at: filledInterval min + matchingClues max put: NSEmptyState ].

							((emptyCases includes: filledInterval max + 1)
								and: [ (emptyCases includes: filledInterval min - 1) not
										and: [ matchingClues second >= matchingClues first
												and: [ matchingClues includesAll: (clues select: [ :clue | clue canInclude: filledInterval max - matchingClues max ]) ] ] ])
								ifTrue: [ self at: filledInterval max - matchingClues max put: NSEmptyState ] ] ] ]
]
