Class {
	#name : #NSCheckIfCluesAreSolvedSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSCheckIfCluesAreSolvedSolver class >> priority [
	^ 190
]

{ #category : #resolving }
NSCheckIfCluesAreSolvedSolver >> resolveCurrentAxis [
	clues do: #checkIsSolved
]
