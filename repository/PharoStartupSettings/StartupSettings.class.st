"
##A small class to organize all the settings that can be defined at startup.

This allow the organization of settings as code, instead of STON settings file, so we can test it from version to version.

Settings can then be deployed to the General Preference folder with a command like:
```language=Pharo
StartupSettings setDefaultSettings
```
and then tested with

```language=Pharo
StartupPreferencesLoader default loadFromDefaultLocations
```
##windows specific settings
To quit without saving, you have 2 steps on windows:
- In """"Pharo.ini"""", add the line ''EnableAltF4Quit=0''
- in setting, include ''closeWithoutSaving''

Other usefull settings one can put in """"Pharo.ini"""":
`ImageFile=""C:\devzone\pharo7-32\Pharo7.0.3-0-32bit-0903ade.image""`
`RunSingleApp=1`
`QuitDialogLabel=""fermeture""`
`QuitDialogMessage=""Quitter Pharo ?""`
`EnableAltF4Quit=0`
`UseOpenGL=1`
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
			settingList maximizePharoWindow.
			settingList scaleGuiToolkit.
			settingList updateFont.
			settingList changeDefaultFont.
			settingList setPersonnalName.
			settingList userLocalDirectory.
			settingList previewWindow.
			settingList defaultLightTheme.
			settingList removePharoLogo.
			settingList closeWithoutSaving.
			settingList gitSettings.
			settingList loadGToolkitNote.
			settingList loadPharoGraphicsNote.
			settingList loadProjectSelectorProject}
]

{ #category : #'look&feel' }
StartupSettings >> changeDefaultFont [

	^ StartupAction
		  name: 'change default font'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [
					  FreeTypeSettings updateFontsAtImageStartup: true.
					  FreeTypeFontProvider current updateFromSystem.
					  StandardFonts defaultFont:
						  (LogicalFont familyName: 'Cascadia Code PL' pointSize: 10).
					  GraphicFontSettings resetAllFontToDefault.
					  StandardFonts windowTitleFont:
						  (LogicalFont familyName: 'Cascadia Code PL' pointSize: 11).
					  StandardFonts haloFont:
						  (LogicalFont familyName: 'Cascadia Code PL' pointSize: 9).
					  StandardFonts balloonFont:
						  (LogicalFont familyName: 'Cascadia Code PL' pointSize: 9) ] ]
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
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [
					  WorldState class compile:
						  'quitSession ^ Smalltalk snapshot: false andQuit: true' ] ]
		  runOnce: true
]

{ #category : #'look&feel' }
StartupSettings >> defaultLightTheme [

	^ StartupAction
		  name: 'default to light theme'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [ PharoLightTheme beCurrent ] ]
		  runOnce: true
]

{ #category : #removing }
StartupSettings >> gitSettings [

	^ StartupAction
		  name: 'git Settings'
		  code: [
			  | credentials store |
			  Iceberg enableMetacelloIntegration: true.
			  Iceberg remoteTypeSelector: #scpUrl.
			  credentials := IceSshCredentials new
				                 host: #*;
				                 username: 'git';
				                 publicKey:
					                 (FileLocator home / '.ssh/id_ed25519.pub')
						                 pathString;
				                 privateKey:
					                 (FileLocator home / '.ssh/id_ed25519')
						                 pathString;
				                 keyPassphrase: '';
				                 yourself.
			  store := IceCredentialStore current.
			  store
				  storeSshCredential: credentials
				  forHostname: credentials host.
			  IceCredentialsProvider useCustomSsh: true ]
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
StartupSettings >> loadGToolkitNote [
	^ StartupAction
		name: 'load gtoolkit note'
		code: [ SmalltalkImage current shortImageName = 'GlamorousToolkit.image'
				  ifTrue: [Metacello new                   
    baseline: 'RdvNote';                                                             
    repository: 'github://rvillemeur/misk_notes/src';                                
    load. ]]
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
StartupSettings >> loadPharoGraphicsNote [

	^ StartupAction
		  name: 'load pharo graphics note'
		  code: [
			  SmalltalkImage current shortImageName = 'GlamorousToolkit.image'
				  ifTrue: [
					  Metacello new
						  baseline: 'PharoGraphics';
						  repository: 'github://rvillemeur/PharoGraphics/src';
						  load ] ]
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
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [
					  Metacello new
						  baseline: 'ProjectSelector';
						  repository: 'github://rvillemeur/project-selector/src';
						  load.
					  ProjectSelector open ] ]
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
StartupSettings >> loadVectorGraphicsProject [

	^ StartupAction
		  name: 'load vector graphics code'
		  code: [ 
			  Metacello new
				  baseline: 'VectorGraphics';
				  repository: 'gitlocal:///c:\devzone\sources\VectorGraphics\src';
				  load ]
		  runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> maximizePharoWindow [

	^ StartupAction
		  name: 'Maximize pharo window'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [
				  Smalltalk currentWorld worldState worldRenderer window maximize ] ]
		  runOnce: true
]

{ #category : #removing }
StartupSettings >> previewWindow [

	^ StartupAction
		  name: 'remove preview window'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [ TaskbarMorph showWindowPreview: false ] ]
		  runOnce: true
]

{ #category : #removing }
StartupSettings >> removePharoLogo [

	^ StartupAction
		  name: 'remove Pharo logo from desktop'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [
					  PolymorphSystemSettings
						  desktopColor: Color gray;
						  showDesktopLogo: false.
					  UITheme currentSettings fastDragging: true ] ]
		  runOnce: true
]

{ #category : #removing }
StartupSettings >> removeWelcomeWindow [

	^ StartupAction
		  name: 'remove welcome window'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [
					  World submorphs
						  select: [ :sm |
							  sm isSystemWindow and: [
								  sm labelString = ((Character value: 0) asString , 'Welcome') ] ]
						  thenDo: [ :window | window delete ] ] ]
		  runOnce: true
]

{ #category : #'external projects' }
StartupSettings >> scaleGuiToolkit [

	^ StartupAction
		  name: 'scaleGuiToolkit'
		  code: [
			  SmalltalkImage current shortImageName = 'GlamorousToolkit.image'
				  ifTrue: [ BlGlutinHostSpace zoomFactor: 1.25 ] ]
		  runOnce: true
]

{ #category : #initialization }
StartupSettings >> setPersonnalName [

	^ StartupAction
		  name: 'set author name'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [ Author fullName: 'RenaudDeVillemeur' ] ]
		  runOnce: true
]

{ #category : #initialization }
StartupSettings >> sharePackageCacheDirectory [

	^ StartupAction
		  name: 'Share package cache directory'
		  code: [ 
			  | sharedPackageCacheDirectory |
			  sharedPackageCacheDirectory := (FileLocator home / 'devzone'
			                                  / 'devspace') asFileReference
				                                 ensureCreateDirectory.
			  MCCacheRepository default directory: sharedPackageCacheDirectory.
			  MCDirectoryRepository defaultDirectoryName:
				  sharedPackageCacheDirectory pathString.
			  IceLibgitRepository shareRepositoriesBetweenImages: true.
			  IceLibgitRepository defaultCodeSubdirectory:
				  sharedPackageCacheDirectory pathString.
			  IceLibgitRepository sharedRepositoriesLocation:
				  sharedPackageCacheDirectory ]
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

{ #category : #'look&feel' }
StartupSettings >> updateDPIAppearance [
"note: this may be fixed in future version of pharo
source taken from https://github.com/pharo-project/pharo/issues/9715"
	^ StartupAction
		  name: 'update dpi appearance'
		  code: [ 
			  OSSDL2BackendWindow compile: 'fetchDPI
	| displayIndex ddpi hdpi vdpi newDiagonalDPI newScreenScaleFactor |
	"In OS X disable the computation of a DPI based scale factor. These values
	are completely wrong and we are getting scale factors that are very large
	even in non-retina display. This workaround does not affect the support for
	retina display because that is handled by fetching the size of the drawing surface."
	Smalltalk os isMacOSX ifTrue: [ 
		diagonalDPI := verticalDPI := horizontalDPI := self screenScaleFactorBaseDPI.
		screenScaleFactor := 1.0.
		^ false
	].

	displayIndex := sdl2Window getDisplayIndex.
	displayIndex < 0 ifTrue: [ ^ false ].
	
	ddpi := ByteArray new: 4.
	hdpi := ByteArray new: 4.
	vdpi := ByteArray new: 4.
	(SDL2 getDisplay: displayIndex ddpi: ddpi hdpi: hdpi vdpi: vdpi) = 0 ifFalse: [ ^ false ].
	
 	ddpi floatAt: 1 put: 96.0.
	ddpi floatAt: 1 put: 96.0.
	ddpi floatAt: 1 put: 96.0.
	
	newDiagonalDPI := ddpi floatAt: 1.
	"Allow automatic scale of factor increments of 5%. We need to
	round due to precision issues which may result in an almost 1 scale factor, but not exactly one.
	This has to be at least a divisor of 25% which are normal scale factor increments that are selectable in Windows.
	"
	newScreenScaleFactor := newDiagonalDPI / self screenScaleFactorBaseDPI roundTo: 0.05.
	(screenScaleFactor closeTo: newScreenScaleFactor) ifTrue: [ ^ false ].

	horizontalDPI := hdpi floatAt: 1.
	verticalDPI := vdpi floatAt: 1.
	diagonalDPI := newDiagonalDPI.
	screenScaleFactor := newScreenScaleFactor.
	^ true'.
	
	WorldMorph scaleFactor: 3.0. ]
		  runOnce: true
]

{ #category : #removing }
StartupSettings >> updateFont [

	^ StartupAction
		  name: 'update system fonts at startup'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [ FreeTypeFontProvider current updateFromSystem ] ]
		  runOnce: true
]

{ #category : #removing }
StartupSettings >> userLocalDirectory [

	^ StartupAction
		  name: 'set user local directory (for saving code)'
		  code: [
			  (SmalltalkImage current shortImageName beginsWith: 'Pharo')
				  ifTrue: [
				  SystemResolver userLocalDirectory: FileLocator home / 'devzone' ] ]
		  runOnce: true
]
