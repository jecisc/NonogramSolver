Class {
	#name : #NSResolver,
	#superclass : #Object,
	#instVars : [
		'horizontalClues',
		'verticalClues',
		'grid',
		'resolutionPass'
	],
	#category : #'NonogramSolver-Model'
}

{ #category : #'class initialization' }
NSResolver class >> initialize [
	self initializeLogger.
	self launchWebSocket
]

{ #category : #'class initialization' }
NSResolver class >> initializeLogger [
	TinyLogger default
		ensureTranscriptLogger;
		timestampFormatBlock:
			[ :aStream :timestamp | 
			timestamp asDate printOn: aStream.
			aStream << ' '.
			timestamp asTime
				print24: true
				on: aStream
			]
]

{ #category : #'class initialization' }
NSResolver class >> launchWebSocket [
	<script>
	self flag: #todo. "make port configurable + restart on primitive failure (check Telescope Cytoscape)"
	ZnServer stopDefault.
	ZnServer startDefaultOn: 1802.
	ZnServer default
		delegate:
			(ZnWebSocketDelegate
				handler: [ :webSocket | 
					[ webSocket runWith: [ :message | webSocket sendMessage: (self on: message) ] ]
						on: ConnectionClosed , PrimitiveFailed
						do: [  ] ])
]

{ #category : #'instance creation' }
NSResolver class >> on: aDOM [
	| result |
	('Time to solve: '
		,
			[ result := self new
				on: aDOM;
				resolve;
				solution ] timeToRun asString) record.
	^ result
]

{ #category : #'as yet unclassified' }
NSResolver class >> scripts [
	'const socket = new WebSocket("ws://localhost:1802");

// Connection opened
socket.addEventListener("open", function (event) {
    socket.send(document.getElementsByClassName("nonogram_table")[0].innerHTML);
});

// Listen for messages
socket.addEventListener("message", function (event) {
	const data = JSON.parse(event.data);
   data.filled.forEach(check);
   data.empty.forEach(empty);
});

function check(value, index, array) {
	var clickEvent = new MouseEvent("mousedown", { view: window, button: 0});
	document.getElementById(value).dispatchEvent (clickEvent);
}

function empty(value, index, array) {
	var clickEvent = new MouseEvent("mousedown", { view: window, button: 2});
	document.getElementById(value).dispatchEvent (clickEvent);
}'.
	'ZnServer stopDefault.
ZnServer startDefaultOn: 1802.
ZnServer default delegate: (ZnWebSocketDelegate handler:
   [ :webSocket |
      [ webSocket runWith: [ :message |
		webSocket sendMessage: (NSResolver on: message) ]
      ]
      on: ConnectionClosed
      do: [  ] ])'
]

{ #category : #'as yet unclassified' }
NSResolver >> at: anInteger at: anInteger2 [
	^ grid at: anInteger at: anInteger2
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

{ #category : #initialization }
NSResolver >> initialize [
	super initialize.
	resolutionPass := 1
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
	horizontalClues := NSColumnsClues buildFrom: (document xPath: '//td[@class=''nmtt'']') anyOne resolver: self.
	verticalClues := NSLinesClues buildFrom: (document xPath: '//td[@class=''nmtl'']') anyOne resolver: self.
	horizontalClues do: [ :clues | clues do: [ :clue | clue addPossibleInterval: (1 to: verticalClues size) ] ].
	verticalClues do: [ :clues | clues do: [ :clue | clue addPossibleInterval: (1 to: horizontalClues size) ] ].
	grid := NSGrid width: horizontalClues size height: verticalClues size
]

{ #category : #'as yet unclassified' }
NSResolver >> resolve [
	self
		execute: [ self resolveWith: NSAbstractSolver solvers.

			[ self isResolved not and: [ self wasGridRecentlyUpdated ] ] whileTrue: [ self resolveWith: NSAbstractSolver reapplyableSolvers ] ]
		recordedAs: 'Resolve'
]

{ #category : #'as yet unclassified' }
NSResolver >> resolveWith: aCollectionOfResolver [
	"We run all solvers but if one ends the resolution, we stop there."

	self
		execute: [ aCollectionOfResolver
				do: [ :solver | 
					solver resolve: self.
					self isResolved ifTrue: [ ^ self ] ] ]
		recordedAs: 'Pass ' , resolutionPass asString.
	resolutionPass := resolutionPass + 1
]

{ #category : #'as yet unclassified' }
NSResolver >> solution [
	| result filled empty |
	result := Dictionary new.
	filled := OrderedCollection new.
	empty := OrderedCollection new.
	1 to: grid numberOfColumns do: [ :columnIndex | 
		1 to: grid numberOfLines do: [ :lineIndex | 
			(grid at: lineIndex at: columnIndex) isFilled ifTrue: [ filled add: 'nmf' , (columnIndex - 1) asString , '_' , (lineIndex - 1) asString ].
			(grid at: lineIndex at: columnIndex) isEmpty ifTrue: [ empty add: 'nmf' , (columnIndex - 1) asString , '_' , (lineIndex - 1) asString ] ] ].
	result at: 'filled' put: filled asArray.
	result at: 'empty' put: empty asArray.
	^ STONJSON toString: result
]

{ #category : #'as yet unclassified' }
NSResolver >> wasGridRecentlyUpdated [
	| wasRecentlyUpdated |
	wasRecentlyUpdated := grid wasRecentlyUpdated.
	grid resetUpdateChecker.
	^ wasRecentlyUpdated
]
