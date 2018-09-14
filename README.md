<<<<<<< HEAD
# PharoStartupSettings
=======
Settings configuration to customize pharo automatically at startup:


```smalltalk
Metacello new
				baseline: 'PharoStartupSettings';
				repository: 'github://rvillemeur/PharoStartupSettings/repository';
				load
```

Then, add/remove/update method in StartupSettings class. Don't forget to update the class side method *setDefaultSettings* with message you want to add on startup

To deploy them, run
```smalltalk
  StartupSettings setDefaultSettings
```
>>>>>>> 897be457e9ab9d33cf01eaeba64c5b2b3ba87da9
