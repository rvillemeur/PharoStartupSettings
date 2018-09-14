Class {
	#name : #BaselineOfPharoStartupSettings,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoStartupSettings
}

{ #category : #baselines }
BaselineOfPharoStartupSettings >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'PharoStartupSettings']
]
