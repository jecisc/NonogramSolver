Class {
	#name : #NSVerticalClues,
	#superclass : #NSAbstractClues,
	#category : #NonogramSolver
}

{ #category : #initialization }
NSVerticalClues >> buildFrom: aXMLElement [ 
	| lines |
	self flag: #improve.
	lines := aXMLElement nodes anyOne nodes anyOne nodes.
	clues := Array new: lines size.
	1 to: clues size do: [ :index | clues at: index put: OrderedCollection new ].
	lines doWithIndex: [ :line :lineIndex | 
		line nodes reverseDo: [ :node | node contentString = ' ' ifFalse: [ (clues at: lineIndex) add: node contentString asNumber ] ].
 ]
]
