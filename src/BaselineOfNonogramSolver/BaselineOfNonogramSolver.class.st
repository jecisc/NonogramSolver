"
I am a baseline to define the structure and dependencies of the NonogramSolver project.
"
Class {
	#name : #BaselineOfNonogramSolver,
	#superclass : #BaselineOf,
	#category : #BaselineOfNonogramSolver
}

{ #category : #baseline }
BaselineOfNonogramSolver >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Dependencies"
			self
				webSocket: spec;
				xmlParserHTML: spec;
				xpath: spec.

			"Packages"
			spec package: 'NonogramSolver' with: [ spec requires: #('ZincHTTPComponents' 'XPath' 'XMLParserHTML') ] ].
]

{ #category : #accessing }
BaselineOfNonogramSolver >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #dependencies }
BaselineOfNonogramSolver >> webSocket: spec [
	spec
		baseline: 'ZincHTTPComponents'
		with: [ spec
				loads: #('WebSocket');
				repository: 'github://svenvc/zinc:v3.0.1/repository' ]
]

{ #category : #dependencies }
BaselineOfNonogramSolver >> xmlParserHTML: spec [
	spec baseline: 'XMLParserHTML' with: [ spec repository: 'github://pharo-contributions/XML-XMLParserHTML/src' ]
]

{ #category : #dependencies }
BaselineOfNonogramSolver >> xpath: spec [
	spec baseline: 'XPath' with: [ spec repository: 'github://pharo-contributions/XML-XPath/src' ]
]
