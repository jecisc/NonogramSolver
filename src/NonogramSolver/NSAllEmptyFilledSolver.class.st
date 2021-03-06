"
Description
--------------------

I am a solver checking if a line is empty. In that case I'll fill it with empty cases.
"
Class {
	#name : #NSAllEmptyFilledSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #testing }
NSAllEmptyFilledSolver class >> canBeReapplied [
	^ false
]

{ #category : #accessing }
NSAllEmptyFilledSolver class >> priority [
	^ 5
]

{ #category : #resolve }
NSAllEmptyFilledSolver >> resolveCurrentAxis [
	clues ifEmpty: [ 1 to: axisSize do: [ :index | self at: index put: NSEmptyState ] ]
]
