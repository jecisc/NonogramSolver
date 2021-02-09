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
	cluesAxis := NSCluesAxis ofSize: lines size cluesList: self.
	lines doWithIndex: [ :line :index | line nodes do: [ :node | cluesAxis addClue: node contentString ifNeededAt: index ] ]
]
