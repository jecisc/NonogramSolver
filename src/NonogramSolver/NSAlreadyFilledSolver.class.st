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
		withUnfinishedLinesDo: [ :lineIndex :lineClue | 
			(lineClue size = 1 and: [ lineClue anyOne = self numberOfColumns ])
				ifTrue: [ 1 to: self numberOfColumns do: [ :columnIndex | self at: lineIndex at: columnIndex put: NSFilledState ] ] ].
	self withUnfinishedColumnsDo: [ :columnIndex :columnClue | (columnClue size = 1 and: [ columnClue anyOne = self numberOfLines ])
				ifTrue: [ 1 to: self numberOfColumns do: [ :lineIndex | self at: lineIndex at: columnIndex put: NSFilledState ] ] ]
]
