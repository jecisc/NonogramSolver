Class {
	#name : #NSAlreadyFilledSolver,
	#superclass : #NSAbstractSolver,
	#category : #NonogramSolver
}

{ #category : #accessing }
NSAlreadyFilledSolver class >> priority [
	^ 10
]

{ #category : #resolve }
NSAlreadyFilledSolver >> resolve [
	self withUnfinishedAxisDo: [ :axisIndex :clues | clues size = 1 ifTrue: [ clues anyOne checkIsSolved ] ]
]
