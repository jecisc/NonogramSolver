Class {
	#name : #NSCluesAxis,
	#superclass : #Object,
	#instVars : [
		'clues',
		'cluesList'
	],
	#category : #NonogramSolver
}

{ #category : #'instance creation' }
NSCluesAxis class >> cluesList: aClueList [
	^ self new
		cluesList: aClueList;
		yourself
]

{ #category : #adding }
NSCluesAxis >> addClue: aValue [
	clues add: (NSClue clue: aValue asNumber axis: self)
]

{ #category : #accessing }
NSCluesAxis >> anyOne [
	^ clues anyOne
]

{ #category : #accessing }
NSCluesAxis >> at: anInteger [
	^ clues at: anInteger
]

{ #category : #accessing }
NSCluesAxis >> at: anInteger put: anObject [
	^ clues at: anInteger put: anObject
]

{ #category : #accessing }
NSCluesAxis >> axisSize [
	^ self ifLineClues: [ self grid numberOfColumns ] ifColumnClues: [ self grid numberOfLines ]
]

{ #category : #checking }
NSCluesAxis >> banIntervalOf: aNSClue [
	"When we solve a clue, we know that its interval and the borns around it are forbidden to the other clues."

	| indexOfSolvedClue |
	indexOfSolvedClue := self indexOf: aNSClue.
	clues
		doWithIndex: [ :clue :index | 
			"If we have a clue before the solved clue, we remove everything after the case before this clue."
			index < indexOfSolvedClue ifTrue: [ clue banFromPossibleInterval: (aNSClue possibleInterval min - 1 to: self axisSize) ].
			"If we have a clue after the solved clue, we remove everything before the case of after this clue"
			index > indexOfSolvedClue ifTrue: [ clue banFromPossibleInterval: (1 to: aNSClue possibleInterval max + 1) ] ]
]

{ #category : #checking }
NSCluesAxis >> check [
	self isResolved ifTrue: [ ^ self ].

	self checkIfAxisIsFullyFilled.
	self checkIfFilledIntervalCanFinishAClue.
	self checkPossibleIntervalsCanBeShortenWithEmptyCases.
	clues do: #check.
	self checkIfAllCluesAreSolvedThatTheAxeIsResolved
]

{ #category : #checking }
NSCluesAxis >> checkIfAllCluesAreSolvedThatTheAxeIsResolved [
	(self unresolvedClues isEmpty and: [ self isResolved not ])
		ifTrue: [ self gridAxis
				doWithIndex: [ :state :index | 
					state isKnown
						ifFalse: [ self ifLineClues: [ self grid at: self index at: index put: NSEmptyState ] ifColumnClues: [ self grid at: index at: self index put: NSEmptyState ] ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfAxisIsFullyFilled [
	| filledIntervals |
	filledIntervals := self gridAxis filledIntervals.
	(filledIntervals size = self size) ifFalse: [ ^ self ].
	
	filledIntervals doWithIndex: [ :interval :index | (interval size = (self at: index) value) ifFalse: [ ^ self ] ].

	"If all filled interval matches the clues, then the line is full and we can ensure the clues are updated."
	filledIntervals doWithIndex: [ :interval :index | (self at: index) restrainPossibleIntervalWith: interval ]
]

{ #category : #checking }
NSCluesAxis >> checkIfFilledIntervalCanFinishAClue [
	"If a filled interval matches only one clue and is the same size as this clue, then we can resolve the clue."

	| possibleCluesForFilledIntervals |
	possibleCluesForFilledIntervals := (self gridAxis filledIntervals collect: [ :interval | interval -> (self possibleCluesForFilledInterval: interval) ]) asDictionary.
	possibleCluesForFilledIntervals keysAndValuesDo: [ :interval :cls | (cls size = 1 and: [ cls anyOne value = interval size ]) ifTrue: [ cls anyOne restrainPossibleIntervalWith: interval ] ]
]

{ #category : #checking }
NSCluesAxis >> checkPossibleIntervalsCanBeShortenWithEmptyCases [
	"If the possible interval of a clue contains an empty case that does not allow to fit the clue before or after it, we can restrain the possible interval of the clue to exclude the beginning or the end."

	self gridAxis emptyIntervals flattened
		ifNotEmpty: [ :emptyIndexes | 
			self unresolvedClues
				do: [ :clue | 
					emptyIndexes
						select: [ :index | clue possibleInterval includes: index ]
						thenDo: [ :index | 
							| intervalToConsider |
							intervalToConsider := clue possibleInterval min to: index.
							intervalToConsider size <= clue value ifTrue: [ clue banFromPossibleInterval: intervalToConsider ].

							intervalToConsider := index to: clue possibleInterval max.
							intervalToConsider size <= clue value ifTrue: [ clue banFromPossibleInterval: intervalToConsider ] ] ] ]
]

{ #category : #accessing }
NSCluesAxis >> clues [
	^ clues
]

{ #category : #accessing }
NSCluesAxis >> clues: anObject [
	clues := anObject
]

{ #category : #accessing }
NSCluesAxis >> cluesList [
	^ cluesList
]

{ #category : #accessing }
NSCluesAxis >> cluesList: anObject [
	cluesList := anObject
]

{ #category : #enumerating }
NSCluesAxis >> do: aBlockClosure [ 
	clues do: aBlockClosure
]

{ #category : #'as yet unclassified' }
NSCluesAxis >> doWithIndex: aBlockClosure [ 
	^ clues doWithIndex: aBlockClosure
]

{ #category : #accessing }
NSCluesAxis >> first [
	^ clues first
]

{ #category : #accessing }
NSCluesAxis >> grid [
	^ cluesList grid
]

{ #category : #accessing }
NSCluesAxis >> gridAxis [
	^ self ifLineClues: [ self grid lineAt: self index ] ifColumnClues: [ self grid columnAt: self index ]
]

{ #category : #testing }
NSCluesAxis >> ifEmpty: aBlockClosure [ 
	^ clues ifEmpty: aBlockClosure 
]

{ #category : #testing }
NSCluesAxis >> ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 [ 
	^ cluesList ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 
]

{ #category : #accessing }
NSCluesAxis >> index [
	^ cluesList indexOf: self
]

{ #category : #accessing }
NSCluesAxis >> indexOf: aNSClue [ 
	^ clues indexOf: aNSClue
]

{ #category : #initialization }
NSCluesAxis >> initialize [
	super initialize.
	clues := OrderedCollection new
]

{ #category : #enumeration }
NSCluesAxis >> inject: aCollection into: aBlockClosure [ 
	^ clues inject: aCollection into: aBlockClosure 
]

{ #category : #checking }
NSCluesAxis >> isResolved [
	^ self
		ifLineClues: [ self grid lineIsAllKnown: self index ]
		ifColumnClues: [ self grid columnIsAllKnown: self index ]
]

{ #category : #accessing }
NSCluesAxis >> last [
	^ clues last
]

{ #category : #accessing }
NSCluesAxis >> possibleCluesForFilledInterval: interval [
	"I return all the clues that can contain an interval of filled cases.
	The interval cannot be bigger than the clue size and et needs to be included in the possible interval of the clue."

	^ clues select: [ :clue | clue value >= interval size and: [ clue possibleInterval includesAll: interval ] ]
]

{ #category : #printing }
NSCluesAxis >> printOn: aStream [
	super printOn: aStream.
	
	aStream
		space;
		print: (clues collect: #value) asArray
]

{ #category : #accessing }
NSCluesAxis >> reverse [
	^ clues reverse
]

{ #category : #accessing }
NSCluesAxis >> size [
	^ clues size
]

{ #category : #accessing }
NSCluesAxis >> unresolvedClues [
	^ clues reject: #isSolved
]
