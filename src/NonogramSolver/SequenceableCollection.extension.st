Extension { #name : #SequenceableCollection }

{ #category : #'*NonogramSolver' }
SequenceableCollection >> filledIntervals [
	| result currentInterval |
	result := OrderedCollection new.
	self
		doWithIndex: [ :each :index | 
			each isFilled
				ifTrue: [ currentInterval := (currentInterval
						ifNil: [ index to: index ]
						ifNotNil: [ currentInterval min to: index ]) ]
				ifFalse: [ currentInterval
						ifNotNil: [ result add: currentInterval.
							currentInterval := nil ] ] ].
	currentInterval ifNotNil: [ result add: currentInterval ].
	^ result
]
