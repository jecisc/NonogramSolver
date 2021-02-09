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
	cluesAxis := NSCluesAxis ofSize: lines anyOne nodes size cluesList: self.
	lines
		do: [ :line | 
			line nodes
				doWithIndex: [ :node :columnIndex | node contentString = ' ' ifFalse: [ (cluesAxis at: columnIndex) add: (NSClue clue: node contentString asNumber) ] ] ]
]
