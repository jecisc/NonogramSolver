Class {
	#name : #NSAxisWithAllSolvedCluesCanBeSolvedSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSAxisWithAllSolvedCluesCanBeSolvedSolver class >> priority [
	^ 200
]

{ #category : #resolving }
NSAxisWithAllSolvedCluesCanBeSolvedSolver >> resolveCurrentAxis [
	(self unresolvedClues isEmpty and: [ clues isResolved not ])
		ifTrue: [ clues gridAxis doWithIndex: [ :state :index | state isKnown ifFalse: [ self at: index put: NSEmptyState ] ] ]
]
