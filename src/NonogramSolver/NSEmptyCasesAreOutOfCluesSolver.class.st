Class {
	#name : #NSEmptyCasesAreOutOfCluesSolver,
	#superclass : #NSAbstractSolver,
	#category : #'NonogramSolver-Solvers'
}

{ #category : #accessing }
NSEmptyCasesAreOutOfCluesSolver class >> priority [
	^ 70
]

{ #category : #resolving }
NSEmptyCasesAreOutOfCluesSolver >> resolve [
	"Remove all empty intervals from the possible intervals of clues.
	Example:
	
	3 | | | | | |x| | | | | | |x| | | |
	
	If the possible intervals for 3 were { (1 to: 16) } then we can make it { (1 to: 5) . (7 to: 12) . (14 to: 16) }"

	self
		withUnfinishedAxisDo: [ :clues :axisSize | 
			clues gridAxis emptyIntervals
				ifNotEmpty: [ :emptyIntervals | clues unresolvedClues do: [ :clue | emptyIntervals do: [ :emptyInterval | clue ban: emptyInterval ] ] ] ]
]
