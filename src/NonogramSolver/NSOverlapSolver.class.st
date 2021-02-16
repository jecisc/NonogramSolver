Class {
	#name : #NSOverlapSolver,
	#superclass : #NSAbstractSolver,
	#instVars : [
		'counter'
	],
	#category : #NonogramSolver
}

{ #category : #accessing }
NSOverlapSolver class >> priority [
	^ 20
]

{ #category : #'as yet unclassified' }
NSOverlapSolver >> resolve [
	self
		withUnfinishedAxisDo: [ :clues :axisSize | 
			| endToBeginInterval beginToEndInterval |
			counter := 1.
			beginToEndInterval := clues
				collectWithIndex: [ :clue :index | 
					| interval |
					interval := counter to: counter + clue value - 1.
					(clue canIncludeAll: interval) ifFalse: [ interval := interval + ((clue possibleIntervals detect: [ :int | int min >= counter ]) min - interval min) ].
					"If the interval is followed by filled cases, then we can move it to embded it."
					[ interval max + 1 <= axisSize and: [ (clues inGridAt: interval max + 1) isFilled ] ] whileTrue: [ interval := interval + 1 ].
					counter := interval max + 2.
					interval ].

			[ clues gridAxis filledIntervals reversed
				detect: [ :filledInterval | beginToEndInterval noneSatisfy: [ :int | int includesAll: filledInterval ] ]
				ifFound: [ :filledInterval | 
					| intervalToShift indexOfIntervalToShift |
					intervalToShift := beginToEndInterval reversed detect: [ :interval | interval max < filledInterval min and: [ interval size >= filledInterval size ] ].
					indexOfIntervalToShift := beginToEndInterval indexOf: intervalToShift.
					beginToEndInterval at: indexOfIntervalToShift put: (intervalToShift + (filledInterval max - intervalToShift max)).
					"self assert: indexOfIntervalToShift = beginToEndInterval size description: 'If we have case it is not true, we need to shift the following intervals.'."
					
					
					
					
					"| intervalToShift indexOfLastUpdatedInterval |
					intervalToShift := beginToEndInterval reverse detect: [ :interval | interval max < filledInterval ].
					indexOfLastUpdatedInterval := beginToEndInterval indexOf: intervalToShift.
					beginToEndInterval at: indexOfLastUpdatedInterval put: intervalToShift + (filledInterval - intervalToShift max).
					[ indexOfLastUpdatedInterval = beginToEndInterval size ]
						whileFalse: [ (beginToEndInterval at: indexOfLastUpdatedInterval + 1) min > (beginToEndInterval at: indexOfLastUpdatedInterval) max
								ifTrue: [ indexOfLastUpdatedInterval := beginToEndInterval size ]
								ifFalse: [ | previousIntervalToShift |
									previousIntervalToShift := beginToEndInterval at: indexOfLastUpdatedInterval.
									indexOfLastUpdatedInterval := indexOfLastUpdatedInterval + 1.
									intervalToShift := beginToEndInterval at: indexOfLastUpdatedInterval.
									beginToEndInterval at: indexOfLastUpdatedInterval put: intervalToShift + (previousIntervalToShift max - intervalToShift min + 1) ] ]."
					"true" false ]
				ifNone: [ false ] ] whileTrue.

			counter := axisSize.
			endToBeginInterval := (clues reverse
				collectWithIndex: [ :clue :index | 
					| interval |
					interval := counter - (clue value - 1) to: counter.
					(clue canIncludeAll: interval)
						ifFalse: [ interval := interval - (interval max - (clue possibleIntervals reversed detect: [ :int | int max <= counter ]) max) ].
					"If the interval is followed by filled cases, then we can move it to embded it."
					[ interval min - 1 > 0 and: [ (clues inGridAt: interval min - 1) isFilled ] ] whileTrue: [ interval := interval - 1 ].
					counter := interval min - 2.
					interval ]) reversed.



			"[ clues gridAxis filledIntervals flattened
				detect: [ :index | endToBeginInterval noneSatisfy: [ :int | int includes: index ] ]
				ifFound: [ :index | 
					| intervalToShift indexOfLastUpdatedInterval |
					intervalToShift := endToBeginInterval detect: [ :interval | interval min > index ].
					indexOfLastUpdatedInterval := endToBeginInterval indexOf: intervalToShift.
					endToBeginInterval at: indexOfLastUpdatedInterval put: intervalToShift - (intervalToShift min - index).
					[ indexOfLastUpdatedInterval = 1 ]
						whileFalse: [ (endToBeginInterval at: indexOfLastUpdatedInterval - 1) max < intervalToShift min
								ifTrue: [ indexOfLastUpdatedInterval := 1 ]
								ifFalse: [ 1halt. 
									indexOfLastUpdatedInterval := indexOfLastUpdatedInterval - 1 ] ].
					true ]
				ifNone: [ false ] ] whileTrue."

			counter := 1.
			beginToEndInterval
				with: endToBeginInterval
				do: [ :int1 :int2 | 
					(clues at: counter) restrainTo: (int1 min to: int2 max).
					(int1 intersection: int2) do: [ :index | clues inGridAt: index put: NSFilledState ].
					counter := counter + 1 ] ]
]
