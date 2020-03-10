"
A small class to organize all the settings that can be defined at startup.
This allow the organization of settings as code, instead of STON settings file, so we can test it from version to version.

Settings can then be deployed to the General Preference folder with a command like:
""StartupSettings setDefaultSettings""

and then tested with
""StartupPreferencesLoader default loadFromDefaultLocations.""

To quit without saving, you have 2 steps on windows:
In Pharo.ini, add the line 'EnableAltF4Quit=0'
Then, in setting, include 'closeWithoutSaving'

Other usefull settings in Pharo.ini:
ImageFile=""C:\devzone\pharo7-32\Pharo7.0.3-0-32bit-0903ade.image""
RunSingleApp=1
QuitDialogLabel=""fermeture""
QuitDialogMessage=""Quitter Pharo ?""
EnableAltF4Quit=0 
UseOpenGL=1

"
Class {
	#name : #StartupSettings,
	#superclass : #Object,
	#category : #PharoStartupSettings
}

{ #category : #initialization }
StartupSettings class >> setDefaultSettings [
	| settingList |
	settingList := self new.
	StartupPreferencesLoader default
		addAtStartupInGeneralPreferenceFolder:
			{settingList removeWelcomeWindow.
			settingList setPersonnalName.
			settingList loadCozySettings.
			settingList defaultLightTheme.
			settingList removePharoLogo.
			settingList closeWithoutSaving.
			settingList gitSettings.
			settingList sharePackageCacheDirectory.
			settingList loadMirageWindowManagement.
			settingList loadVistaCursor.
			settingList loadProjectSelectorProject}
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
StartupSettings >> closeWithoutSaving [
	^ StartupAction
		name: 'close without saving'
		code: [ WorldState class
				compile: 'quitSession ^ Smalltalk snapshot: false andQuit: true' ]
		runOnce: true
]

{ #category : #'look&feel' }
StartupSettings >> defaultLightTheme [
	^ StartupAction
		name: 'default to light theme'
		code: [ PharoLightTheme beCurrent ]
		runOnce: true
]

{ #category : #removing }
StartupSettings >> gitSettings [
	^ StartupAction
		name: 'git Settings'
		code: [ Iceberg enableMetacelloIntegration: true.
			Iceberg remoteTypeSelector: #httpsUrl.]
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
StartupSettings >> loadCozySettings [
	^ StartupAction
		name: 'load cozy settings'
		code: [ Metacello new
				baseline: 'Cozy';
				repository: 'github://Ducasse/Cozy/tree/master/src';
				load ]
		runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> loadMirageWindowManagement [
	^ StartupAction
		name: 'load mirage window management'
		code: [ Metacello new
				repository: 'github://JulienDelplanque/Mirage:v2.1.0/src';
				baseline: 'Mirage';
				load.
			MIModel install: true ]
		runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> loadPomodoroTimer [
	^ StartupAction
		name: 'load pomodoro timer'
		code: [ Metacello new
				repository: 'github://astares/Pharo-Pomodoro/src';
				baseline: 'Pomodoro';
				load ]
		runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> loadProjectSelectorProject [
	^ StartupAction
		name: 'Project Selector loading'
		code: [ Metacello new
				baseline: 'ProjectSelector';
				repository: 'github://rvillemeur/project-selector/src';
				load.
			ProjectSelector open ]
		runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> loadRdvSettingsProject [
	^ StartupAction
		name: 'Pharo startup Settings automatic loading'
		code: [ Metacello new
				baseline: 'PharoStartupSettings';
				repository: 'github://rvillemeur/PharoStartupSettings/repository';
				load ]
		runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> loadVistaCursor [
	^ StartupAction
		name: 'load vista cursor'
		code: [ Metacello new
				repository: 'github://astares/Pharo-VistaCursors/src';
				baseline: 'VistaCursors';
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
				select: [ :sm | sm isSystemWindow and: [ sm labelString = ((Character value: 0) asString, 'Welcome') ] ]
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
			sharedPackageCacheDirectory := (FileLocator home / 'devzone' / 'devspace') asFileReference  ensureCreateDirectory.
			MCCacheRepository default directory: sharedPackageCacheDirectory.
			MCDirectoryRepository defaultDirectoryName: sharedPackageCacheDirectory pathString .
			IceLibgitRepository shareRepositoriesBetweenImages: true.
			IceLibgitRepository defaultCodeSubdirectory: sharedPackageCacheDirectory pathString.
			IceLibgitRepository sharedRepositoriesLocation: sharedPackageCacheDirectory.
			GTPlayBook defaultCacheDirectory: sharedPackageCacheDirectory.
			GTPlayBook defaultStashDirectory: sharedPackageCacheDirectory ]
		runOnce: true
]

{ #category : #removing }
StartupSettings >> startCalypsoBrowserOnSelectedPackage [
	^ StartupAction
		name: 'Start Calypso on selected package'
		code: [ | filter query scope browser |
			filter := ClyItemNameFilter new pattern: (ClyRegexPattern with: 'argen').
			scope := ClyNavigationEnvironment currentImageScope.
			query := ClyFilterQuery for: (ClyAllPackagesQuery sortedFrom: scope) filter: filter.
			query requiredResult: (ClySortedQueryResult using: ClySortByNameFunction ascending).
			browser := ClyFullBrowser open.
			browser packageView showQuery: query.
			browser selectPackage: (query execute allItems at: 1) ]
		runOnce: true
]

{ #category : #removing }
StartupSettings >> startStaticFileWebServer [
	^ StartupAction
		name: 'Start static file web server'
		code: [ (ZnServer startDefaultOn: 8080)
				logToTranscript;
				delegate:
					(ZnStaticFileServerDelegate new
						directory: 'C:\devzone\webgl' asFileReference;
						mimeTypeExpirations: ZnStaticFileServerDelegate defaultMimeTypeExpirations;
						yourself) ]
		runOnce: true
]

{ #category : #removing }
StartupSettings >> startTestRunnerOnSelectedPackage [
	^ StartupAction
		name: 'Start Test Runner on selected package'
		code: [ TestRunner new
				packageSearchUpdate: 'Argentum';
				selectAllPackages;
				runAll;
				open ]
		runOnce: true
]
