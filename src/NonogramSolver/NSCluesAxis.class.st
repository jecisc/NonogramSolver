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
			index < indexOfSolvedClue ifTrue: [ clue ban: (aNSClue possibleInterval min - 1 to: self axisSize) ].
			"If we have a clue after the solved clue, we remove everything before the case of after this clue"
			index > indexOfSolvedClue ifTrue: [ clue ban: (1 to: aNSClue possibleInterval max + 1) ] ]
]

{ #category : #checking }
NSCluesAxis >> check [
	self isResolved ifTrue: [ ^ self ].

	self checkIfFilledIntervalCanFinishAClue.
	self checkIfAxisIsFullyFilled.
	self checkRemoveEmptyCasesFromPossibleIntervals.
	self checkIfFilledIntervalAreEntirelyInClues.
	self checkIfFilledIntervalsAreBiggerThanClueValue.
	self checkRestrainPossibleIntervalsIfFilledIntervalMatchesOnlyOneClue.
	self checkAllFilledIntervalsOfTheSizeOfTheirMatchingCluesAreSurroundedByEmptyCases.
	self checkIfClueContainsAFillIntervalOfItsSizeThatSurroundingsAreNotInPossibleIntervals.
	self checkIfFilledIntervalCloseToEmptyCasesCanBeExpandedToTheSizeOfTheSmallestMatchingClue.
	self checkIfFilledIntervalsCanReducePossibleIntervalsSize.
	self checkIfCloseFilledIntervalsCanBeJoined.
	self checkIfUniquePossibleIntervalIsSmallerThanTwiceTheClueValue.
	self checkFilleIntervalNextToEmptyCaseWatchingTwoCluesCanAddAnEmptyCase.
	clues do: #check.
	self checkIfAllCluesAreSolvedThatTheAxeIsResolved
]

{ #category : #checking }
NSCluesAxis >> checkAllFilledIntervalsOfTheSizeOfTheirMatchingCluesAreSurroundedByEmptyCases [
	self gridAxis filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					(filledInterval size = matchingClues anyOne value and: [ matchingClues size > 1 and: [ (matchingClues collect: #value) asSet size = 1 ] ])
						ifTrue: [ filledInterval min = 1 ifFalse: [ self inGridAt: filledInterval min - 1 put: NSEmptyState ].
							filledInterval max = self axisSize ifFalse: [ self inGridAt: filledInterval max + 1 put: NSEmptyState ] ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkFilleIntervalNextToEmptyCaseWatchingTwoCluesCanAddAnEmptyCase [
	| axis emptyCases |
	axis := self gridAxis.
	"Add also the borders of the axis."
	emptyCases := axis emptyIntervals flattened asOrderedCollection
		addFirst: 0;
		addLast: self axisSize + 1;
		yourself.
	axis filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					matchingClues size = 2
						ifTrue: [ | maxValue |
							maxValue := (matchingClues collect: #value) max.

							((emptyCases includes: filledInterval min - 1)
								and: [ (emptyCases includes: filledInterval max + 1) not
										and: [ matchingClues first >= matchingClues second
												and: [ matchingClues includesAll: (clues select: [ :clue | clue canInclude: filledInterval min + maxValue ]) ] ] ])
								ifTrue: [ self inGridAt: filledInterval min + maxValue put: NSEmptyState ].

							((emptyCases includes: filledInterval max + 1)
								and: [ (emptyCases includes: filledInterval min - 1) not
										and: [ matchingClues second >= matchingClues first
												and: [ matchingClues includesAll: (clues select: [ :clue | clue canInclude: filledInterval max - maxValue ]) ] ] ])
								ifTrue: [ self inGridAt: filledInterval max - maxValue put: NSEmptyState ] ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfAllCluesAreSolvedThatTheAxeIsResolved [
	(self unresolvedClues isEmpty and: [ self isResolved not ])
		ifTrue: [ self gridAxis doWithIndex: [ :state :index | state isKnown ifFalse: [ self inGridAt: index put: NSEmptyState ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfAxisIsFullyFilled [
	| filledIntervals |
	filledIntervals := self gridAxis filledIntervals.
	(filledIntervals size = self size) ifFalse: [ ^ self ].
	
	filledIntervals doWithIndex: [ :interval :index | (interval size = (self at: index) value) ifFalse: [ ^ self ] ].

	"If all filled interval matches the clues, then the line is full and we can ensure the clues are updated."
	filledIntervals doWithIndex: [ :interval :index | (self at: index) restrainTo: interval ]
]

{ #category : #checking }
NSCluesAxis >> checkIfCloseFilledIntervalsCanBeJoined [
	"1 2 1 | | | |o| |o| | | | | | |
	can be:
	1 2 1 | | | |o|x|o| | | | | | |"

	self gridAxis filledIntervals
		overlappingPairsDo: [ :filledInterval1 :filledInterval2 | 
			filledInterval2 min - filledInterval1 max = 2
				ifTrue: [ ((self unresolvedClues select: [ :clue | (clue canIncludeAll: filledInterval1) and: [ clue canIncludeAll: filledInterval2 ] ])
						ifEmpty: [ true ]
						ifNotEmpty: [ :matchingClues | (filledInterval1 min to: filledInterval2 max) size > matchingClues max ])
						ifTrue: [ self inGridAt: filledInterval1 max + 1 put: NSEmptyState ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfClueContainsAFillIntervalOfItsSizeThatSurroundingsAreNotInPossibleIntervals [
	self gridAxis filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue value = filledInterval size and: [ clue canIncludeAll: filledInterval ] ])
				do: [ :clue | 
					filledInterval min > 1 ifTrue: [ clue ban: (filledInterval min - 1 to: filledInterval min - 1) ].
					filledInterval max < self axisSize ifTrue: [ clue ban: (filledInterval max + 1 to: filledInterval max + 1) ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfFilledIntervalAreEntirelyInClues [
	"If a filled interval is only partly in a clue, we can remove it and the cases surrounding it since we need at least one space between two intervals."

	self gridAxis filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | (clue canIncludeAny: filledInterval) and: [ (clue canIncludeAll: filledInterval) not ] ])
				ifNotEmpty: [ :matchingClues | matchingClues do: [ :clue | clue ban: (filledInterval min - 1 to: filledInterval max + 1) ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfFilledIntervalCanFinishAClue [
	"If a filled interval matches only one clue and is the same size as this clue, then we can resolve the clue."

	self gridAxis filledIntervals
		do: [ :filledInterval | 
			| matchingClues |
			matchingClues := self unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ].
			(matchingClues size = 1 and: [ matchingClues anyOne value = filledInterval size ]) ifTrue: [ matchingClues anyOne restrainTo: filledInterval ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfFilledIntervalCloseToEmptyCasesCanBeExpandedToTheSizeOfTheSmallestMatchingClue [
	"For example if we have:
	| | |x|x| | |o|o|o| | | | | | |
	And the filled interval can be associated to a clue of size 7 and another of size 9, then we can fill like this:
	| | |x|x| | |o|o|o|o|o| | | | |"

	| axis emptyIntervals |
	axis := self gridAxis.
	"Add also the borders of the axis."
	emptyIntervals := axis emptyIntervals
		addFirst: (0 to: 0);
		addLast: (self axisSize + 1 to: self axisSize + 1);
		yourself.
	axis filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAll: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					emptyIntervals
						detect: [ :interval | interval includesAny: (filledInterval max to: filledInterval min + matchingClues min) ]
						ifFound: [ :emptyInterval | (emptyInterval min - matchingClues min to: filledInterval min - 1) do: [ :index | self inGridAt: index put: NSFilledState ] ].

					emptyIntervals
						detect: [ :interval | interval includesAny: (filledInterval max - matchingClues min to: filledInterval max) ]
						ifFound: [ :emptyInterval | filledInterval max + 1 to: emptyInterval max + matchingClues min do: [ :index | self inGridAt: index put: NSFilledState ] ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfFilledIntervalsAreBiggerThanClueValue [
	"If a filled interval is bigger than a matching clue, we can remove it and the cases surrounding it since we need at least one space between two intervals."

	self gridAxis filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | (clue canIncludeAny: filledInterval) and: [ clue < filledInterval size ] ])
				ifNotEmpty: [ :matchingClues | matchingClues do: [ :clue | clue ban: (filledInterval min - 1 to: filledInterval max + 1) ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfFilledIntervalsCanReducePossibleIntervalsSize [
	"For example if we have a clue whose possible interval is:
	
	| | |o|o| | | |
	
	And its size is 3, then we can ban the first case because if the clue was there, then we fill more cases than required."

	self gridAxis filledIntervals
		do: [ :filledInterval | 
			self unresolvedClues
				do: [ :clue | 
					clue possibleIntervals
						detect: [ :interval | interval includesAny: filledInterval ]
						ifFound: [ :possibleInterval | 
							(possibleInterval min to: filledInterval max) size > clue
								ifTrue: [ ((possibleInterval min to: possibleInterval min + clue) intersection: filledInterval)
										ifNotEmpty: [ clue ban: (possibleInterval min to: filledInterval max - clue) ] ].
							(filledInterval min to: possibleInterval max) size > clue
								ifTrue: [ ((possibleInterval max - clue to: possibleInterval max) intersection: filledInterval)
										ifNotEmpty: [ clue ban: (filledInterval min + clue to: possibleInterval max) ] ] ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkIfUniquePossibleIntervalIsSmallerThanTwiceTheClueValue [
	self unresolvedClues
		do: [ :clue | 
			clue possibleIntervals size = 1
				ifTrue: [ | possibleInterval |
					possibleInterval := clue possibleInterval.
					((possibleInterval min to: possibleInterval min + clue - 1) intersection: (possibleInterval max - clue + 1 to: possibleInterval max))
						ifNotEmpty: [ :intersection | intersection do: [ :index | self inGridAt: index put: NSFilledState ] ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkRemoveEmptyCasesFromPossibleIntervals [
	"Remove all empty intervals from the possible intervals of clues."

	self gridAxis emptyIntervals
		ifNotEmpty: [ :emptyIntervals | self unresolvedClues do: [ :clue | emptyIntervals do: [ :emptyInterval | clue ban: emptyInterval ] ] ]
]

{ #category : #checking }
NSCluesAxis >> checkRestrainPossibleIntervalsIfFilledIntervalMatchesOnlyOneClue [
	"If a filled interval is in a clue, then we can restrain the possibleIntervals of the clue to remove cases too far from this interval.
	
	Implementation detail:
		we can use #canIncludeAny: instead of #canIncludeAll: because this check is called after #checkIfFilledIntervalAreEntirelyInClues"

	self gridAxis filledIntervals
		do: [ :filledInterval | 
			(self unresolvedClues select: [ :clue | clue canIncludeAny: filledInterval ])
				ifNotEmpty: [ :matchingClues | 
					matchingClues size = 1
						ifTrue: [ | clue |
							clue := matchingClues anyOne.
							clue restrainTo: (filledInterval max - clue + 1 to: filledInterval min + clue - 1) ] ] ]
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
NSCluesAxis >> collectWithIndex: aBlockClosure [ 
	^ clues collectWithIndex: aBlockClosure
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
NSCluesAxis >> inGridAt: index [
	^ self ifLineClues: [ self grid at: self index at: index ] ifColumnClues: [ self grid at: index at: self index ]
]

{ #category : #accessing }
NSCluesAxis >> inGridAt: index put: aState [
	self ifLineClues: [ self grid at: self index at: index put: aState ] ifColumnClues: [ self grid at: index at: self index put: aState ]
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

{ #category : #enumerating }
NSCluesAxis >> select: aBlockClosure [ 
	^ clues select: aBlockClosure
]

{ #category : #accessing }
NSCluesAxis >> size [
	^ clues size
]

{ #category : #accessing }
NSCluesAxis >> unresolvedClues [
	^ clues reject: #isSolved
]
