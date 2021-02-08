Class {
	#name : #NSResolver,
	#superclass : #Object,
	#instVars : [
		'horizontalClues',
		'verticalClues',
		'grid'
	],
	#category : #NonogramSolver
}

{ #category : #'instance creation' }
NSResolver class >> on: aDOM [ 
	^ self new
		on: aDOM;
		resolve;
		solution
]

{ #category : #'as yet unclassified' }
NSResolver class >> scripts [
	'const socket = new WebSocket("ws://localhost:1801");

// Connection opened
socket.addEventListener("open", function (event) {
    socket.send(document.getElementsByClassName("nonogram_table")[0].innerHTML);
});

// Listen for messages
socket.addEventListener("message", function (event) {
    const filled = JSON.parse(event.data);
	filled.forEach(check)
});

function check(value, index, array) {
	var clickEvent = document.createEvent ("MouseEvents");
	clickEvent.initEvent ("mousedown", true, true);
	document.getElementById(value).dispatchEvent (clickEvent);
}'.
	'ZnServer stopDefault.
ZnServer startDefaultOn: 1801.
ZnServer default delegate: (ZnWebSocketDelegate handler:
   [ :webSocket |
      [ webSocket runWith: [ :message |
		webSocket sendMessage: (NSResolver on: message) ]
      ]
      on: ConnectionClosed
      do: [  ] ])'
]

{ #category : #'as yet unclassified' }
NSResolver >> at: anInteger at: anInteger2 put: aState [ 
	grid at: anInteger at: anInteger2 put: aState 
]

{ #category : #accessing }
NSResolver >> clueForColumn: columnIndex [
	^ horizontalClues at: columnIndex
]

{ #category : #accessing }
NSResolver >> clueForLine: lineIndex [
	^ verticalClues at: lineIndex
]

{ #category : #testing }
NSResolver >> columnIsAllKnown: columnIndex [ 
	^ grid columnIsAllKnown: columnIndex
]

{ #category : #accessing }
NSResolver >> grid [
	^ grid
]

{ #category : #testing }
NSResolver >> isResolved [
	^ grid isResolved
]

{ #category : #testing }
NSResolver >> lineIsAllKnown: lineIndex [ 
	^ grid lineIsAllKnown: lineIndex
]

{ #category : #accessing }
NSResolver >> numberOfColumns [
	^ grid numberOfColumns
]

{ #category : #accessing }
NSResolver >> numberOfLines [
	^ grid numberOfLines
]

{ #category : #initalize }
NSResolver >> on: aDOM [ 
	| document |
	document := XMLHTMLParser parse: aDOM.
	horizontalClues := NSHorizontalClues buildFrom: (document xPath: '//td[@class=''nmtt'']') anyOne.
	verticalClues := NSVerticalClues buildFrom: (document xPath: '//td[@class=''nmtl'']') anyOne.
	horizontalClues do: [ :clues | clues do: [ :clue | clue possibleInterval: (1 to: verticalClues size) ] ].
	verticalClues do: [ :clues | clues do: [ :clue | clue possibleInterval: (1 to: horizontalClues size) ] ].
	grid := NSGrid width: horizontalClues size height: verticalClues size
]

{ #category : #'as yet unclassified' }
NSResolver >> resolve [
	NSAbstractSolver solvers do: [ :solver | solver resolve: self ] separatedBy: [ self isResolved ifTrue: [ ^ self ] ]
]

{ #category : #'as yet unclassified' }
NSResolver >> solution [
	| filled |
	filled := OrderedCollection new.
	1 to: grid numberOfColumns do: [ :columnIndex | 
		1 to: grid numberOfLines do: [ :lineIndex |
			(grid at: lineIndex at: columnIndex) isFilled ifTrue: [ filled add: 'nmf' , (columnIndex - 1) asString , '_' , (lineIndex - 1) asString ] ] ].
	^ STONJSON toString: filled asArray
]
