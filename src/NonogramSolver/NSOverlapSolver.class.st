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
			| invertedIntervals directIntervals |
			counter := 1.
			directIntervals := clues
				collectWithIndex: [ :clue :index | 
					| interval |
					interval := counter to: counter + clue - 1.
					(clue canIncludeAll: interval) ifFalse: [ interval := interval + ((clue possibleIntervals detect: [ :int | int min >= counter ]) min - interval min) ].
					"If the interval is followed by filled cases, then we can move it to embded it."
					[ interval max + 1 <= axisSize and: [ (clues inGridAt: interval max + 1) isFilled ] ] whileTrue: [ interval := interval + 1 ].
					counter := interval max + 2.
					interval ].

			[ clues gridAxis filledIntervals reversed
				detect: [ :filledInterval | directIntervals noneSatisfy: [ :int | int includesAll: filledInterval ] ]
				ifFound: [ :filledInterval | 
					| intervalToShift currentIndex |
					intervalToShift := directIntervals reversed detect: [ :interval | interval min < filledInterval min and: [ interval size >= filledInterval size ] ].
					currentIndex := directIntervals indexOf: intervalToShift.
					directIntervals at: currentIndex put: intervalToShift + (filledInterval max - intervalToShift max).
					[ currentIndex < directIntervals size ]
						whileTrue: [ | currentInterval nextInterval |
							currentInterval := directIntervals at: currentIndex.
							nextInterval := directIntervals at: currentIndex + 1.
							currentIndex := currentInterval max + 1 < nextInterval min
								ifTrue: [ directIntervals size ]
								ifFalse: [ directIntervals at: currentIndex + 1 put: nextInterval + currentInterval max - nextInterval min + 2.
									currentIndex + 1 ] ].
					true ]
				ifNone: [ false ] ] whileTrue.

			counter := axisSize.
			invertedIntervals := (clues reverse
				collectWithIndex: [ :clue :index | 
					| interval |
					interval := counter - clue + 1 to: counter.
					(clue canIncludeAll: interval)
						ifFalse: [ interval := interval - (interval max - (clue possibleIntervals reversed detect: [ :int | int max <= counter ]) max) ].
					"If the interval is followed by filled cases, then we can move it to embded it."
					[ interval min - 1 > 0 and: [ (clues inGridAt: interval min - 1) isFilled ] ] whileTrue: [ interval := interval - 1 ].
					counter := interval min - 2.
					interval ]) reversed.

			[ clues gridAxis filledIntervals
				detect: [ :filledInterval | invertedIntervals noneSatisfy: [ :int | int includesAll: filledInterval ] ]
				ifFound: [ :filledInterval | 
					| intervalToShift currentIndex |
					intervalToShift := invertedIntervals detect: [ :interval | interval max > filledInterval max and: [ interval size >= filledInterval size ] ].
					currentIndex := invertedIntervals indexOf: intervalToShift.
					invertedIntervals at: currentIndex put: intervalToShift - (intervalToShift min - filledInterval min).
					[ currentIndex > 1 ]
						whileTrue: [ | currentInterval nextInterval |
							currentInterval := invertedIntervals at: currentIndex.
							nextInterval := invertedIntervals at: currentIndex - 1.
							currentIndex := nextInterval max < (currentInterval min - 1)
								ifTrue: [ 1 ]
								ifFalse: [ invertedIntervals at: currentIndex - 1 put: nextInterval - (nextInterval max - currentInterval min + 2).
									currentIndex - 1 ] ].
					true ]
				ifNone: [ false ] ] whileTrue.

			counter := 1.
			directIntervals
				with: invertedIntervals
				do: [ :int1 :int2 | 
					(clues at: counter) restrainTo: (int1 min to: int2 max).
					counter := counter + 1 ] ]
]
