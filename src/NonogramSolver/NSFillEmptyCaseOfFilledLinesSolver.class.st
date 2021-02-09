Class {
	#name : #NSFillEmptyCaseOfFilledLinesSolver,
	#superclass : #NSAbstractSolver,
	#category : #NonogramSolver
}

{ #category : #accessing }
NSFillEmptyCaseOfFilledLinesSolver class >> priority [
	^ 40
]

{ #category : #resolving }
NSFillEmptyCaseOfFilledLinesSolver >> resolve [
	"self withUnfinishedLinesDo: [ :lineIndex :clues | (clues allSatisfy: #checkIsSolved) ifTrue: [ 1halt.
			clues inject: (1 to: self numberOfColumns) asOrderedCollection into: [ :toFillWithEmpty :clue | toFillWithEmpty removeAllFoundIn: clue possibleInterval; yourself ] ] ].
	self withUnfinishedColumnsDo: [ :columnIndex :clues | (clues allSatisfy: #checkIsSolved) ifTrue: [ 1h ] ]"
]
