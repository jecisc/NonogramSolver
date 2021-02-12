Class {
	#name : #NSGrid,
	#superclass : #Object,
	#instVars : [
		'content',
		'wasRecentlyUpdated'
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
	content at: lineIndex at: columnIndex put: aState.
	wasRecentlyUpdated := true
]

{ #category : #accessing }
NSGrid >> columnAt: anInteger [ 
	^ (1 to: self numberOfLines) collect: [ :each | self at: each at: anInteger ]
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

{ #category : #initialization }
NSGrid >> initialize [
	super initialize.
	self resetUpdateChecker
]

{ #category : #testing }
NSGrid >> isResolved [
	1 to: self numberOfColumns do: [ :columnIndex | 
		1 to: self numberOfLines do: [ :lineIndex | 
			(content at: lineIndex at: columnIndex) isKnown ifFalse: [ ^ false ]  ] ].
	^ true
]

{ #category : #accessing }
NSGrid >> lineAt: anInteger [ 
	^ (1 to: self numberOfColumns) collect: [ :each | self at: anInteger at: each ]
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

{ #category : #initialization }
NSGrid >> resetUpdateChecker [
	wasRecentlyUpdated := false
]

{ #category : #accessing }
NSGrid >> wasRecentlyUpdated [
	^ wasRecentlyUpdated
]

{ #category : #accessing }
NSGrid >> width [
	^ content numberOfColumns
]

{ #category : #initialization }
NSGrid >> width: numberOfColumns height: numberOfLines [
	content := Array2D rows: numberOfLines columns: numberOfColumns element: NSUnknownState
]
