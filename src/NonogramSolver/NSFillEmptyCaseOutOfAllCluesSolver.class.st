Class {
	#name : #NSFillEmptyCaseOutOfAllCluesSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSFillEmptyCaseOutOfAllCluesSolver class >> priority [
	^ 40
]

{ #category : #resolving }
NSFillEmptyCaseOutOfAllCluesSolver >> resolveCurrentAxis [
	(clues inject: (1 to: axisSize) asOrderedCollection into: [ :coll :clue | coll removeAllSuchThat: [ :index | clue canInclude: index ] ])
		ifNotEmpty: [ :toFillWithEmpty | toFillWithEmpty do: [ :index | self at: index put: NSEmptyState ] ]
]
