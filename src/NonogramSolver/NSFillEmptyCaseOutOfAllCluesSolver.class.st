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
		withUnfinishedAxisDo: [ :clues :axisSize | 
			(clues
				inject: (1 to: axisSize) asOrderedCollection
				into: [ :coll :clue | 
					coll
						removeAllFoundIn: clue possibleInterval;
						yourself ])
				ifNotEmpty: [ :toFillWithEmpty | toFillWithEmpty do: [ :index | clues inGridAt: index put: NSEmptyState ] ] ]
]
