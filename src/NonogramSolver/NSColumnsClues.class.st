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
	lines
		doWithIndex:
			[ :line :lineIndex | line nodes do: [ :node | node contentString = ' ' ifFalse: [ (cluesAxis at: lineIndex) add: (NSClue clue: node contentString asNumber) ] ] ]
]
