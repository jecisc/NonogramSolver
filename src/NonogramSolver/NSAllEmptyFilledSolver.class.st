Class {
	#name : #NSAllEmptyFilledSolver,
	#superclass : #NSAbstractSolver,
	#category : #NonogramSolver
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
NSAllEmptyFilledSolver >> resolve [
	self withUnfinishedAxisDo: [ :axisIndex :clues :axisSize | clues ifEmpty: [ 1 to: axisSize do: [ :index | self axisAt: axisIndex at: index put: NSEmptyState for: clues ] ] ]
]
