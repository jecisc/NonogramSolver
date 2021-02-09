Class {
	#name : #NSAllEmptyFilledSolver,
	#superclass : #NSAbstractSolver,
	#category : #NonogramSolver
}

{ #category : #accessing }
NSAllEmptyFilledSolver class >> priority [
	^ 5
]

{ #category : #resolve }
NSAllEmptyFilledSolver >> resolve [
	self
		withUnfinishedLinesDo: [ :lineIndex :clues | clues ifEmpty: [ 1 to: self numberOfColumns do: [ :columnIndex | self at: lineIndex at: columnIndex put: NSEmptyState ] ] ].
	self
		withUnfinishedColumnsDo: [ :columnIndex :clues | clues ifEmpty: [ 1 to: self numberOfLines do: [ :lineIndex | self at: lineIndex at: columnIndex put: NSEmptyState ] ] ]
]
