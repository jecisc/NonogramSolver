Class {
	#name : #NSAxisIsFullyFilledSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSAxisIsFullyFilledSolver class >> priority [
	^ 60
]

{ #category : #resolving }
NSAxisIsFullyFilledSolver >> resolveCurrentAxis [
	self filledIntervals size = clues size ifFalse: [ ^ self ].

	self filledIntervals doWithIndex: [ :interval :index | interval size = (clues at: index) value ifFalse: [ ^ self ] ].

	"If all filled interval matches the clues, then the line is full and we can ensure the clues are updated."
	self filledIntervals doWithIndex: [ :interval :index | (clues at: index) restrainTo: interval ]
]
