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
					(clue canInclude: counter) ifFalse: [ counter := clue possibleIntervals first min ].
					interval := self
						tryToShiftInterval: (counter to: counter + clue value - 1)
						clueValue: clue value
						forClues: clues
						shiftFurther: true.
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
					(clue canInclude: counter) ifFalse: [ counter := clue possibleIntervals last max ].
					interval := self
						tryToShiftInterval: (counter - (clue value - 1) to: counter)
						clueValue: clue value
						forClues: clues
						shiftFurther: false.
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

{ #category : #resolving }
NSOverlapSolver >> tryToShiftInterval: possibleInterval clueValue: clueValue forClues: clues shiftFurther: aBoolean [
	| initialInterval shiftedInterval |
	initialInterval := possibleInterval.
	self flag: #todo. "This might not be needed anymore since we start at the beginning of the possible interval of the clue and the check probably remove the empty cases from the possible interval if it's close to a border."
	[ shiftedInterval := self
		tryToShiftOnceInterval: initialInterval
		clueValue: clueValue
		forClues: clues
		shiftFurther: aBoolean.
	initialInterval = shiftedInterval ] whileFalse: [ initialInterval := shiftedInterval ].	"As long as we can shift, we try to shift once again."
	^ shiftedInterval
]

{ #category : #resolving }
NSOverlapSolver >> tryToShiftOnceInterval: possibleInterval clueValue: clueValue forClues: clues shiftFurther: aBoolean [
	| interval |
	interval := possibleInterval.
	(interval select: [ :i | (clues inGridAt: i) isEmpty ])
		ifNotEmpty: [ :emptyCases | 
			| shift |
			shift := aBoolean
				ifTrue: [ emptyCases max - interval min + 1 ]
				ifFalse: [ interval max - emptyCases min + 1 ].
			counter := aBoolean
				ifTrue: [ counter + shift ]
				ifFalse: [ counter - shift ].
			interval := aBoolean
				ifTrue: [ interval + shift ]
				ifFalse: [ interval - shift ] ].
	^ interval
]
