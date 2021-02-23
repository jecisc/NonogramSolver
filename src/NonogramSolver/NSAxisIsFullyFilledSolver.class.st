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
NSAxisIsFullyFilledSolver >> clues: clues areAllFilledBy: filledIntervals [
	filledIntervals size = clues size ifFalse: [ ^ false ].

	filledIntervals doWithIndex: [ :interval :index | interval size = (clues at: index) value ifFalse: [ ^ false ] ].

	^ true
]

{ #category : #resolving }
NSAxisIsFullyFilledSolver >> resolve [
	self
		withUnfinishedAxisDo: [ :clues :axisSize | 
			| filledIntervals |
			filledIntervals := clues gridAxis filledIntervals.
			(self clues: clues areAllFilledBy: filledIntervals)
				ifTrue:
					[
					"If all filled interval matches the clues, then the line is full and we can ensure the clues are updated."
					filledIntervals doWithIndex: [ :interval :index | (clues at: index) restrainTo: interval ] ] ]
]
