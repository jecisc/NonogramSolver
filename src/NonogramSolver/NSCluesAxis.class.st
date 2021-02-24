Class {
	#name : #NSCluesAxis,
	#superclass : #Object,
	#instVars : [
		'clues',
		'cluesList'
	],
	#category : #'NonogramSolver-Model'
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

{ #category : #enumerating }
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

{ #category : #enumerating }
NSCluesAxis >> inject: aCollection into: aBlockClosure [ 
	^ clues inject: aCollection into: aBlockClosure 
]

{ #category : #testing }
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
