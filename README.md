<a href="https://swift.org" target="_blank"><img src="https://img.shields.io/badge/Language-Swift%203-orange.svg" alt="Language Swift 3"></a>
[![CI Status](http://img.shields.io/travis/ababel2007@yahoo.com/Versioner.svg?style=flat)](https://travis-ci.org/ababel2007@yahoo.com/Versioner)
[![Version](https://img.shields.io/cocoapods/v/Versioner.svg?style=flat)](http://cocoapods.org/pods/Versioner)
[![License](https://img.shields.io/cocoapods/l/Versioner.svg?style=flat)](http://cocoapods.org/pods/Versioner)
[![Platform](https://img.shields.io/cocoapods/p/Versioner.svg?style=flat)](http://cocoapods.org/pods/Versioner)


# Versioner

Your **app version tracker**.

# Usages 
## #1 : Events

* App installed.
```swift
Versioner.currentVersion.isFreshInstall {
	// Welcome user
}
```

* App updated.
```swift
Versioner.currentVersion.isUpdate { (prevVersion) in 
	// Show new features
}
```

* App downgraded
```swift
Versioner.currentVersion.isDowngrade { (prevVersion) in 
	// Disable app or prompt to update
}
```
* App build updated.
```swift
Versioner.currentVersion.isBuildUpdate { (prevVersion) in 
	// Notify tester
}
```
* App build downgraded.
```swift
Versioner.currentVersion.isBuildDowngrade { (prevVersion) in 
	// Clean app data directory or make core data model changes ... etc
}
```
* App launched with number X.
```swift
Versioner.currentVersion.isLaunch(number: 3) { (prevVersion) in 
	/* 
	Launch number X of this version (not all versions together),
                        X = any number you want */

}
```

## #2 : CurrentVersion info
```swift
Versioner.currentVersion.number 	 // Marketing or iTunesConnect version
Versioner.currentVersion.build 		 // Build number
Versioner.currentVersion.launchNumber	 // Number of app launches during this version
Versioner.currentVersion.firstLaunchDate // Date of first launch
Versioner.currentVersion.os_version	 // OS Version when this version first installed
```
## #3 : Operators and Version check 
 
 Execute another specific code in future release
```swift
if Versioner.currentVersion > AppVersion("3.0") {
	// Do new code
        //      ex: call new backend
} else {
        // Do old code
	//      ex: call old backend
}
```
```swift
print(Versioner.currentVersion > AppVersion("3.0.0.1")) // true or false
print(AppVersion("3.0") < AppVersion("3.1")) // true
print(AppVersion("3.0") == AppVersion("3.0")) // true
```

## Installation

Versioner is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Versioner"
```

Then add this line to `application didFinishLaunchingWithOptions` before calling any api method.
```swift
Versioner.initiate()
```

## Author

Husam Aamer , ababel2007@yahoo.com

## License

Made with ❤️ in 🇮🇶 under the MIT license.
