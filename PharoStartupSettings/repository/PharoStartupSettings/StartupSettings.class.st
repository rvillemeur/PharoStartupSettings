"
A small class to organize all the settings that can be defined at startup.
This allow the organization of settings as code, instead of STON settings file, so we can test it from version to version.

Settings can then be deployed to the General Preference folder with a command like:
""StartupSettings setDefaultSettings""

and then tested with
""StartupPreferencesLoader default loadFromDefaultLocations.""
"
Class {
	#name : #StartupSettings,
	#superclass : #Object,
	#category : #PharoStartupSettings
}

{ #category : #'as yet unclassified' }
StartupSettings class >> selectMethodCode: amethodName [
	| method |
	^method := self methodNamed: amethodName.
	"^ method sourceCode"
]

{ #category : #initialization }
StartupSettings class >> setDefaultSettings [
	| settingList |
	settingList := self new.
	StartupPreferencesLoader default
		addAtStartupInGeneralPreferenceFolder:
			{settingList gitSettings.
			settingList sharePackageCacheDirectory.
			settingList loadRdvSettingsProject.
			settingList loadArgentumProject.
			settingList loadDesignPatternProject.
			settingList removeWelcomeWindow.
			settingList setPersonnalName.
			settingList defaultLightTheme.
			settingList removePharoLogo}


]

{ #category : #'look&feel' }
StartupSettings >> changeDebuggerDefault [
	^StartupAction
		name: 'change debugger default'
		code: [ GTGenericStackDebugger alwaysOpenFullDebugger: true ]
		runOnce: true
]

{ #category : #'look&feel' }
StartupSettings >> changeDefaultFont [
	^StartupAction
		name: 'change default font'
		code: [ StandardFonts defaultFont: (LogicalFont familyName: 'Consolas' pointSize: 10).
			GraphicFontSettings resetAllFontToDefault ]
		runOnce: true
]

{ #category : #'look&feel' }
StartupSettings >> changeSyntaxDefault [
	^StartupAction
		name: 'change default syntax settings'
		code: [ "TextEditorDialogWindow autoAccept: true."
			SHPreferences setStyleTableNamed: 'Solarized' ]
		runOnce: true
]

{ #category : #'look&feel' }
StartupSettings >> defaultLightTheme [
	^StartupAction name: 'default to light theme' code: [ PharoLightTheme beCurrent ] runOnce: true
]

{ #category : #removing }
StartupSettings >> gitSettings [
	^ StartupAction
		name: 'git Settings'
		code: [ Iceberg enableMetacelloIntegration: true.
			IceCredentialsProvider useCustomSsh: true.
			"IceCredentialsProvider sshCredentials
				username: 'git';
				publicKey: '/Users/YOUR/.ssh/id_rsa.pub';
				privateKey: '/Users/YOUR/.ssh/id_rsa'."
			"IceCredentialsProvider
				plaintextCredentials:
					(IcePlaintextCredentials new
						username: 'YOUR';
						password: 'YOURGITHUBPASS';
						yourself)."
			Iceberg showSystemRepositories: true.
			IceRepository registry
				detect: [ :each | each name = 'pharo' ]
				ifFound: [ :repo | repo location: 'C:\devzone\devspace\iceberg' asFileReference ] ]
		runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> loadArgentumProject [
	^ StartupAction
		name: 'Argentum automatic loading'
		code: [ Metacello new
				baseline: 'Argentum';
				repository: 'github://rvillemeur/argentum/repository';
				load ]
		runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> loadRdvSettingsProject [
	^ StartupAction
		name: 'Pharo startup Settings automatic loading'
		code: [ Metacello new
				baseline: 'Argentum';
				repository: 'github://rvillemeur/PharoStartupSettings/repository';
				load ]
		runOnce: true
]

{ #category : #removing }
StartupSettings >> removePharoLogo [
	^StartupAction
		name: 'remove Pharo logo from desktop'
		code: [ PolymorphSystemSettings
				desktopColor: Color gray;
				showDesktopLogo: false.
			UITheme currentSettings fastDragging: true ]
		runOnce: true
]

{ #category : #removing }
StartupSettings >> removeWelcomeWindow [
	^StartupAction
		name: 'remove welcome window'
		code: [ World submorphs
				select: [ :sm | sm isSystemWindow and: [ sm labelString = 'Welcome to Pharo6.1' ] ]
				thenDo: [ :window | window delete ] ]
		runOnce: true
]

{ #category : #initialization }
StartupSettings >> setPersonnalName [
	^StartupAction
		name: 'set author name'
		code: [ Author fullName: 'RenaudDeVillemeur' ]
		runOnce: true
]

{ #category : #initialization }
StartupSettings >> sharePackageCacheDirectory [
	^ StartupAction
		name: 'Share package cache directory'
		code: [ | sharedPackageCacheDirectory |
			sharedPackageCacheDirectory := 'C:\devzone\devspace' asFileReference
				ensureCreateDirectory.
			MCCacheRepository default directory: sharedPackageCacheDirectory.
			MCDirectoryRepository defaultDirectoryName: 'C:\devzone\devspace' ]
		runOnce: true
]
