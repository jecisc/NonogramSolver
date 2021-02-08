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
	self
		withUnfinishedLinesDo: [ :lineIndex :clues | 
			(clues size = 1 and: [ clues anyOne value = self numberOfColumns ])
				ifTrue: [ clues anyOne solved.
					1 to: self numberOfColumns do: [ :columnIndex | self at: lineIndex at: columnIndex put: NSFilledState ] ] ].
	self
		withUnfinishedColumnsDo: [ :columnIndex :clues | 
			(clues size = 1 and: [ clues anyOne value = self numberOfLines ])
				ifTrue: [ clues anyOne solved.
					1 to: self numberOfLines do: [ :lineIndex | self at: lineIndex at: columnIndex put: NSFilledState ] ] ]
]
