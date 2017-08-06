[![CI Status](http://img.shields.io/travis/ababel2007@yahoo.com/Versioner.svg?style=flat)](https://travis-ci.org/ababel2007@yahoo.com/Versioner)
[![Version](https://img.shields.io/cocoapods/v/Versioner.svg?style=flat)](http://cocoapods.org/pods/Versioner)
[![License](https://img.shields.io/cocoapods/l/Versioner.svg?style=flat)](http://cocoapods.org/pods/Versioner)
[![Platform](https://img.shields.io/cocoapods/p/Versioner.svg?style=flat)](http://cocoapods.org/pods/Versioner)

# Versioner

Your **app version tracker**.

# Usages 
## #1 : Events

* App installed.
```
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
```
Versioner.currentVersion.isDowngrade { (prevVersion) in 
	// Disable app or prompt to update
}
```
* App build updated.
```
Versioner.currentVersion.isBuildUpdate { (prevVersion) in 
	// Notify tester
}
```
* App build downgraded.
```
Versioner.currentVersion.isBuildDowngrade { (prevVersion) in 
	// Clean app data directory or make core data model changes ... etc
}
```
* App launched with number X.
```
Versioner.currentVersion.isLaunch(number: 3) { (prevVersion) in 
	/* 
	Launch number X of this version (not all versions together),
                        X = any number you want */

}
```

## #2 : Version check
```
        if Versioner.currentVersion > AppVersion("3.0") {
            // Do new code
            //      ex: call new backend
        } else {
            // Do old code
            //      ex: call old backend
        }
```
## #3 : Operators 
```
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

Then add this line to `application didFinishLaunchingWithOptions` in your AppDelegate before calling any api method.
```
Versioner.initiate()
```

## Author

ababel2007@yahoo.com, ababel2007@yahoo.com

## License

Versioner is available under the MIT license. See the LICENSE file for more info.
