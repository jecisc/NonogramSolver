Class {
	#name : #NSCluesList,
	#superclass : #Object,
	#instVars : [
		'cluesAxis',
		'resolver'
	],
	#category : #NonogramSolver
}

{ #category : #'instance creation' }
NSCluesList class >> buildFrom: aXMLElement resolver: aResolver [
	^ self new
		resolver: aResolver;
		buildFrom: aXMLElement;
		yourself
]

{ #category : #accessing }
NSCluesList >> at: anInteger [
	^ cluesAxis at: anInteger
]

{ #category : #accessing }
NSCluesList >> buildFrom: aXMLElement [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
NSCluesList >> cluesAxis [
	^ cluesAxis
]

{ #category : #accessing }
NSCluesList >> cluesAxis: anObject [
	cluesAxis := anObject
]

{ #category : #enumerating }
NSCluesList >> do: aBlockClosure [ 
	cluesAxis do: aBlockClosure
]

{ #category : #accessing }
NSCluesList >> grid [
	^ resolver grid
]

{ #category : #testing }
NSCluesList >> ifLineClues: aBlockClosure ifColumnClues: aBlockClosure2 [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
NSCluesList >> resolver [
	^ resolver
]

{ #category : #accessing }
NSCluesList >> resolver: anObject [
	resolver := anObject
]

{ #category : #accessing }
NSCluesList >> size [
	^ cluesAxis size
]
