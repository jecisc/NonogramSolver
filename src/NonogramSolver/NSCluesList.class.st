Class {
	#name : #NSCluesList,
	#superclass : #Object,
	#instVars : [
		'cluesAxis'
	],
	#category : #NonogramSolver
}

{ #category : #'instance creation' }
NSCluesList class >> buildFrom: aXMLElement [ 
	^ self new
		buildFrom: aXMLElement;
		yourself
]

{ #category : #accessing }
NSCluesList >> at: anInteger [
	^ cluesAxis at: anInteger
]

{ #category : #accessing }
NSCluesList >> buildFrom: arg1 [ 
	^ self subclassResponsibility
]

{ #category : #enumerating }
NSCluesList >> do: aBlockClosure [ 
	cluesAxis do: aBlockClosure
]

{ #category : #accessing }
NSCluesList >> size [
	^ cluesAxis size
]
