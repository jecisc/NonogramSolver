Class {
	#name : #NSAllFilledIntervalsOfTheSizeOfTheirCluesAreSurroundedByEmptyCasesSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSAllFilledIntervalsOfTheSizeOfTheirCluesAreSurroundedByEmptyCasesSolver class >> priority [
	^ 120
]

{ #category : #resolving }
NSAllFilledIntervalsOfTheSizeOfTheirCluesAreSurroundedByEmptyCasesSolver >> resolveCurrentAxis [
	self filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					(filledInterval size = matchingClues anyOne value and: [ matchingClues size > 1 and: [ (matchingClues collect: #value) asSet size = 1 ] ])
						ifTrue: [ filledInterval min = 1 ifFalse: [ self at: filledInterval min - 1 put: NSEmptyState ].
							filledInterval max = axisSize ifFalse: [ self at: filledInterval max + 1 put: NSEmptyState ] ] ] ]
]
