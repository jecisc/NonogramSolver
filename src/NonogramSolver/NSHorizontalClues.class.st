Class {
	#name : #NSHorizontalClues,
	#superclass : #NSAbstractClues,
	#category : #NonogramSolver
}

{ #category : #initialization }
NSHorizontalClues >> buildFrom: aXMLElement [
	| lines |
	self flag: #improve.
	lines := aXMLElement nodes anyOne nodes anyOne nodes.
	clues := Array new: lines anyOne nodes size.
	1 to: clues size do: [ :index | clues at: index put: OrderedCollection new ].
	lines reverse
		do: [ :line | line nodes doWithIndex: [ :node :columnIndex | node contentString = ' ' ifFalse: [ (clues at: columnIndex) add: node contentString asNumber ] ] ]
]
