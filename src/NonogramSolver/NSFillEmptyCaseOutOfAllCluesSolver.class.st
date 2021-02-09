Class {
	#name : #NSFillEmptyCaseOutOfAllCluesSolver,
	#superclass : #NSAbstractSolver,
	#category : #NonogramSolver
}

{ #category : #accessing }
NSFillEmptyCaseOutOfAllCluesSolver class >> priority [
	^ 40
]

{ #category : #resolving }
NSFillEmptyCaseOutOfAllCluesSolver >> resolve [
	self
		withUnfinishedLinesDo: [ :lineIndex :clues :axisSize | 
			(clues
				inject: (1 to: axisSize) asOrderedCollection
				into: [ :coll :clue | 
					coll
						removeAllFoundIn: clue possibleInterval;
						yourself ]) ifNotEmpty: [ :toFillWithEmpty | toFillWithEmpty do: [ :index | self at: lineIndex at: index put: NSEmptyState ] ] ].
	self
		withUnfinishedColumnsDo: [ :columnIndex :clues :axisSize | 
			(clues
				inject: (1 to: axisSize) asOrderedCollection
				into: [ :coll :clue | 
					coll
						removeAllFoundIn: clue possibleInterval;
						yourself ]) ifNotEmpty: [ :toFillWithEmpty | toFillWithEmpty do: [ :index | self at: index at: columnIndex put: NSEmptyState ] ] ].
]
