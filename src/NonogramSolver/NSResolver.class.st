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
		resolve
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
    console.log("Message from server ", event.data);
});'.
	'ZnServer stopDefault.
ZnServer startDefaultOn: 1801.
ZnServer default delegate: (ZnWebSocketDelegate handler:
   [ :webSocket |
      [ webSocket runWith: [ :message |
		NSSolver on: message.
         webSocket sendMessage: ''Todo'' ]
      ]
      on: ConnectionClosed
      do: [ self crLog: ''Ignoring connection close, done'' ] ]).

'
]

{ #category : #'as yet unclassified' }
NSResolver >> at: anInteger at: anInteger2 put: aState [ 
	grid at: anInteger at: anInteger2 put: aState 
]

{ #category : #accessing }
NSResolver >> clueForColumn: columnIndex [
	^ verticalClues at: columnIndex
]

{ #category : #accessing }
NSResolver >> clueForLine: lineIndex [
	^ horizontalClues at: lineIndex
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
	| document horizontalHTMLClues |
	document := XMLHTMLParser parse: aDOM.
	horizontalClues := NSHorizontalClues buildFrom: (document xPath: '//td[@class=''nmtt'']') anyOne.
	verticalClues := NSVerticalClues buildFrom: (document xPath: '//td[@class=''nmtl'']') anyOne.
	grid := NSGrid width: horizontalClues size height: verticalClues size
]

{ #category : #'as yet unclassified' }
NSResolver >> resolve [
	NSAbstractSolver solvers do: [ :solver | solver resolve: self ] separatedBy: [ self isResolved ifTrue: [ 1halt ] ].
	1halt.
]
