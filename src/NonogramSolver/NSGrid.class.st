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

{ #category : #'as yet unclassified' }
NSGrid >> at: anInteger at: anInteger2 put: aState [ 
	content at: anInteger at: anInteger2 put: aState 
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
NSGrid >> width: anInteger height: anInteger2 [
	content := Array2D rows: anInteger columns: anInteger2 element: NSUnknownState
]
