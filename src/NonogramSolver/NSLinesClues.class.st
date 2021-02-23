Class {
	#name : #NSLinesClues,
	#superclass : #NSCluesList,
	#category : #'NonogramSolver-Model'
}

{ #category : #initialization }
NSLinesClues >> buildFrom: aXMLElement [
	| lines |
	self flag: #improve.
	lines := aXMLElement nodes anyOne nodes anyOne nodes.
	cluesAxis := Array ofSize: lines size.
	1 to: cluesAxis size do: [ :index | cluesAxis at: index put: (NSCluesAxis cluesList: self) ].
	lines doWithIndex: [ :line :index | line nodes do: [ :node | self addClue: node contentString ifNeededAt: index ] ]
]

{ #category : #testing }
NSLinesClues >> ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 [ 
	^ aBlockClosure value
]
