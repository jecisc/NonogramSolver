Class {
	#name : #NSUniqueIntervalSmallerThanTwiceTheValueSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSUniqueIntervalSmallerThanTwiceTheValueSolver class >> priority [
	^ 170
]

{ #category : #resolving }
NSUniqueIntervalSmallerThanTwiceTheValueSolver >> resolveCurrentAxis [
	self unresolvedClues
		do: [ :clue | 
			clue possibleIntervals size = 1
				ifTrue: [ | possibleInterval |
					possibleInterval := clue possibleInterval.
					((possibleInterval min to: possibleInterval min + clue - 1) intersection: (possibleInterval max - clue + 1 to: possibleInterval max))
						ifNotEmpty: [ :intersection | intersection do: [ :index | self at: index put: NSFilledState ] ] ] ]
]
