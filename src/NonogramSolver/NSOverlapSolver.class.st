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

{ #category : #resolving }
NSOverlapSolver >> resolve [
	self
		withUnfinishedAxisDo: [ :clues :axisSize | 
			| endToBeginInterval beginToEndInterval |
			counter := 1.
			beginToEndInterval := clues
				collectWithIndex: [ :clue :index | 
					| interval |
					(clue canIncludeAll: (counter to: counter + clue value - 1)) ifFalse: [ counter := (clue possibleIntervals detect: [ :int | int min >= counter ]) min ].
					interval := counter to: counter + clue value - 1.
					counter := counter + clue value + 1.
					"If the interval is followed by filled cases, then we can move it to embded it."
					[ counter - 1 <= axisSize and: [ (clues inGridAt: counter - 1) isFilled ] ]
						whileTrue: [ interval := interval + 1.
							counter := counter + 1 ].
					interval ].


			counter := axisSize.
			endToBeginInterval := (clues reverse
				collectWithIndex: [ :clue :index | 
					| interval |
					(clue canIncludeAll: (counter - (clue value - 1) to: counter))
						ifFalse: [ counter := (clue possibleIntervals reversed detect: [ :int | int max <= counter ]) max ].
					interval := counter - (clue value - 1) to: counter.
					counter := counter - (clue value + 1).
					"If the interval is followed by filled cases, then we can move it to embded it."
					[ counter + 1 > 0 and: [ (clues inGridAt: counter + 1) isFilled ] ]
						whileTrue: [ interval := interval - 1.
							counter := counter - 1 ].
					interval ]) reversed.

			"			
			[ clues gridAxis filledIntervals flattened
				detect: [ :index | beginToEndInterval noneSatisfy: [ :int | int includes: index ] ]
				ifFound: [ :index | 
					| intervalToShift indexOfLastUpdatedInterval |
					intervalToShift := beginToEndInterval reverse detect: [ :interval | interval max < index ].
					indexOfLastUpdatedInterval := beginToEndInterval indexOf: intervalToShift.
					beginToEndInterval at: indexOfLastUpdatedInterval put: intervalToShift + (index - intervalToShift max).
					[ indexOfLastUpdatedInterval = beginToEndInterval size ]
						whileFalse: [ (beginToEndInterval at: indexOfLastUpdatedInterval + 1) min > ((beginToEndInterval at: indexOfLastUpdatedInterval)) max
								ifTrue: [ indexOfLastUpdatedInterval := beginToEndInterval size ]
								ifFalse: [ 
									| previousIntervalToShift |
									previousIntervalToShift := (beginToEndInterval at: indexOfLastUpdatedInterval).
									indexOfLastUpdatedInterval := indexOfLastUpdatedInterval + 1.
									intervalToShift := (beginToEndInterval at: indexOfLastUpdatedInterval).
									beginToEndInterval at: indexOfLastUpdatedInterval put: intervalToShift + (previousIntervalToShift max - intervalToShift min + 1).
									] ].
					true ]
				ifNone: [ false ] ] whileTrue."

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
