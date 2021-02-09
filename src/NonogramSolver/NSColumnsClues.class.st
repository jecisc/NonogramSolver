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
	cluesAxis := NSCluesAxis ofSize: lines anyOne nodes size cluesList: self.
	lines do: [ :line | line nodes doWithIndex: [ :node :index | cluesAxis addClue: node contentString ifNeededAt: index ] ]
]

{ #category : #testing }
NSColumnsClues >> ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 [ 
	^ aBlockClosure2 value
]
