Class {
	#name : #NSClueContainingAFillIntervalOfItsSizeCannotContainItsSurroundingsSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSClueContainingAFillIntervalOfItsSizeCannotContainItsSurroundingsSolver class >> priority [
	^ 130
]

{ #category : #resolving }
NSClueContainingAFillIntervalOfItsSizeCannotContainItsSurroundingsSolver >> resolveCurrentAxis [
	self filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue value = filledInterval size and: [ clue canIncludeAll: filledInterval ] ])
				do: [ :clue | 
					filledInterval min > 1 ifTrue: [ clue ban: (filledInterval min - 1 to: filledInterval min - 1) ].
					filledInterval max < axisSize ifTrue: [ clue ban: (filledInterval max + 1 to: filledInterval max + 1) ] ] ]
]
