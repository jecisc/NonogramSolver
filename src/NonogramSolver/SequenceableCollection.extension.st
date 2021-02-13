Extension { #name : #SequenceableCollection }

{ #category : #'*NonogramSolver' }
SequenceableCollection >> emptyIntervals [
	^ self intervalsMatching: #isEmpty
]

{ #category : #'*NonogramSolver' }
SequenceableCollection >> filledIntervals [
	^ self intervalsMatching: #isFilled
]

{ #category : #'*NonogramSolver' }
SequenceableCollection >> intervalsMatching: aBlock [
	| result currentInterval |
	result := OrderedCollection new.
	self
		doWithIndex: [ :each :index | 
			(aBlock value: each)
				ifTrue: [ currentInterval := (currentInterval
						ifNil: [ index to: index ]
						ifNotNil: [ currentInterval min to: index ]) ]
				ifFalse: [ currentInterval
						ifNotNil: [ result add: currentInterval.
							currentInterval := nil ] ] ].
	currentInterval ifNotNil: [ result add: currentInterval ].
	^ result
]
