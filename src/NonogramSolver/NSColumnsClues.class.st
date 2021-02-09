Class {
	#name : #NSColumnsClues,
	#superclass : #NSCluesList,
	#category : #NonogramSolver
}

{ #category : #initialization }
NSColumnsClues >> buildFrom: aXMLElement [
	| lines |
	self flag: #improve.
	lines := aXMLElement nodes anyOne nodes anyOne nodes.
	cluesAxis := Array ofSize: lines anyOne nodes size.
	1 to: cluesAxis size do: [ :index | cluesAxis at: index put: (NSCluesAxis cluesList: self) ].
	lines do: [ :line | line nodes doWithIndex: [ :node :index | self addClue: node contentString ifNeededAt: index ] ]
]

{ #category : #testing }
NSColumnsClues >> ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 [ 
	^ aBlockClosure2 value
]
