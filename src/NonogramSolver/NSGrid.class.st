Class {
	#name : #NSGrid,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : #NonogramSolver
}

{ #category : #'instance creation' }
NSGrid class >> width: anInteger height: anInteger2 [ 
	^ self new
		width: anInteger height: anInteger2;
		yourself
]

{ #category : #accessing }
NSGrid >> at: lineIndex at: columnIndex [ 
	^ content at: lineIndex at: columnIndex 
]

{ #category : #'as yet unclassified' }
NSGrid >> at: lineIndex at: columnIndex put: aState [ 
	content at: lineIndex at: columnIndex put: aState 
]

{ #category : #testing }
NSGrid >> columnIsAllKnown: columnIndex [ 
	1 to: self numberOfLines do: [ :lineIndex | (content at: lineIndex at: columnIndex) isKnown ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
NSGrid >> content [
	^ content
]

{ #category : #accessing }
NSGrid >> height [
	^ content numberOfRows
]

{ #category : #testing }
NSGrid >> isResolved [
	1 to: self numberOfColumns do: [ :columnIndex | 
		1 to: self numberOfLines do: [ :lineIndex | 
			(content at: lineIndex at: columnIndex) isKnown ifFalse: [ ^ false ]  ] ].
	^ true
]

{ #category : #testing }
NSGrid >> lineIsAllKnown: lineIndex [ 
	1 to: self numberOfColumns do: [ :columnIndex | (content at: lineIndex at: columnIndex) isKnown ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
NSGrid >> numberOfColumns [
	^ content numberOfColumns
]

{ #category : #accessing }
NSGrid >> numberOfLines [
	^ content numberOfRows
]

{ #category : #accessing }
NSGrid >> width [
	^ content numberOfColumns
]

{ #category : #initialization }
NSGrid >> width: numberOfColumns height: numberOfLines [
	content := Array2D rows: numberOfLines columns: numberOfColumns element: NSUnknownState
]
