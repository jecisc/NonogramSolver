Class {
	#name : #NSAbstractSolver,
	#superclass : #Object,
	#instVars : [
		'resolver',
		'clues',
		'axisSize',
		'emptyIntervals',
		'filledIntervals'
	],
	#category : #'NonogramSolver-Solvers'
}

{ #category : #testing }
NSAbstractSolver class >> canBeReapplied [
	^ true
]

{ #category : #accessing }
NSAbstractSolver class >> priority [
	^ self subclassResponsibility
]

{ #category : #accessing }
NSAbstractSolver class >> reapplyableSolvers [
	^ (self allSubclasses select: #canBeReapplied) sorted: #priority ascending
]

{ #category : #resolving }
NSAbstractSolver class >> resolve: aResolver [
	self
		execute: [ self new
				resolver: aResolver;
				resolve ]
		recordedAs: 'Execute ' , self name
]

{ #category : #accessing }
NSAbstractSolver class >> solvers [
	^ self allSubclasses sorted: #priority ascending
]

{ #category : #accessing }
NSAbstractSolver >> at: anIndex [
	^ clues inGridAt: anIndex
]

{ #category : #accessing }
NSAbstractSolver >> at: anIndex put: aState [
	^ clues inGridAt: anIndex put: aState
]

{ #category : #accessing }
NSAbstractSolver >> clueForColumn: columnIndex [ 
	^ resolver clueForColumn: columnIndex
]

{ #category : #accessing }
NSAbstractSolver >> clueForLine: lineIndex [
	^ resolver clueForLine: lineIndex
]

{ #category : #accessing }
NSAbstractSolver >> columnIsAllKnown: columnIndex [
	^ resolver columnIsAllKnown: columnIndex
]

{ #category : #accessing }
NSAbstractSolver >> emptyIntervals [
	^ emptyIntervals ifNil: [ emptyIntervals := clues gridAxis emptyIntervals ]
]

{ #category : #accessing }
NSAbstractSolver >> filledIntervals [
	^ filledIntervals ifNil: [ filledIntervals := clues gridAxis filledIntervals ]
]

{ #category : #testing }
NSAbstractSolver >> lineIsAllKnown: lineIndex [
	^ resolver lineIsAllKnown: lineIndex
]

{ #category : #accessing }
NSAbstractSolver >> numberOfColumns [
	^ resolver numberOfColumns
]

{ #category : #accessing }
NSAbstractSolver >> numberOfLines [
	^ resolver numberOfLines
]

{ #category : #initialization }
NSAbstractSolver >> reset [
	filledIntervals := emptyIntervals := nil
]

{ #category : #resolving }
NSAbstractSolver >> resolve [
	self withUnfinishedAxisDo: [ self resolveCurrentAxis ]
]

{ #category : #resolving }
NSAbstractSolver >> resolveCurrentAxis [
	self subclassResponsibility
]

{ #category : #accessing }
NSAbstractSolver >> resolver: aNSResolver [ 
	resolver := aNSResolver
]

{ #category : #accessing }
NSAbstractSolver >> unresolvedClues [
	^ clues unresolvedClues
]

{ #category : #resolve }
NSAbstractSolver >> withUnfinishedAxisDo: aBlock [
	self
		withUnfinishedLinesDo: aBlock;
		withUnfinishedColumnsDo: aBlock
]

{ #category : #resolve }
NSAbstractSolver >> withUnfinishedColumnsDo: aBlock [
	1 to: self numberOfColumns do: [ :columnIndex | 
		(self columnIsAllKnown: columnIndex)
			ifFalse: [ clues := self clueForColumn: columnIndex.
				axisSize := self numberOfLines.
				self reset.
				aBlock value ] ]
]

{ #category : #resolve }
NSAbstractSolver >> withUnfinishedLinesDo: aBlock [
	1 to: self numberOfLines do: [ :lineIndex | 
		(self lineIsAllKnown: lineIndex)
			ifFalse: [ clues := self clueForLine: lineIndex.
				axisSize := self numberOfColumns.
				self reset.
				aBlock value ] ]
]
