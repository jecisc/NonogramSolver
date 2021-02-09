Class {
	#name : #NSLinesClues,
	#superclass : #NSCluesList,
	#category : #NonogramSolver
}

{ #category : #initialization }
NSLinesClues >> buildFrom: aXMLElement [
	| lines |
	self flag: #improve.
	lines := aXMLElement nodes anyOne nodes anyOne nodes.
	cluesAxis := NSCluesAxis ofSize: lines size cluesList: self.
	lines doWithIndex: [ :line :index | line nodes do: [ :node | cluesAxis addClue: node contentString ifNeededAt: index ] ]
]

{ #category : #testing }
NSLinesClues >> ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 [ 
	^ aBlockClosure value
]
