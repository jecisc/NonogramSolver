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
NSCluesAxis class >> ofSize: anInteger cluesList: aClueList [
	^ self new
		ofSize: anInteger;
		cluesList: aClueList;
		yourself
]

{ #category : #adding }
NSCluesAxis >> addClue: aValue ifNeededAt: anIndex [
	aValue = ' ' ifTrue: [ ^ self ].

	(self at: anIndex) add: (NSClue clue: aValue asNumber axis: self)
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

{ #category : #accessing }
NSCluesAxis >> grid [
	^ cluesList grid
]

{ #category : #testing }
NSCluesAxis >> ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 [ 
	^ cluesList ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 
]

{ #category : #accessing }
NSCluesAxis >> indexOf: aNSClue [ 
	^ clues indexOf: (clues detect: [ :c | c includes: aNSClue ])
]

{ #category : #'instance creation' }
NSCluesAxis >> ofSize: anInteger [
	clues := Array new: anInteger.
	1 to: anInteger do: [ :index | self at: index put: OrderedCollection new ]
]

{ #category : #accessing }
NSCluesAxis >> size [
	^ clues size
]
