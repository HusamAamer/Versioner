//
//  AppVersioning.swift
//  Repo
//
//  Created by Husam Aamer on 8/3/17.
//  Copyright © 2017 FH. All rights reserved.
//

import UIKit


class AppVersion:NSObject, NSCoding {
    
    let number          : String
    let build           : String
    var launchNumber     : Int
    let firstLaunchDate : Date
    let os_version      : String
    
    init(_ withNumber:String, build:String = "NA", launchNumber:Int = 1) {
        self.number = withNumber
        self.build = build
        self.launchNumber = launchNumber
        self.firstLaunchDate = Date()
        self.os_version = UIDevice.current.systemVersion
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(number,           forKey: "number")
        aCoder.encode(build ,           forKey: "build")
        aCoder.encode(launchNumber ,     forKey: "launchNumber")
        aCoder.encode(firstLaunchDate , forKey: "firstLaunchDate")
        aCoder.encode(os_version ,      forKey: "os_version")
    }
    required init?(coder aDecoder: NSCoder) {
        
        number = aDecoder.decodeObject(forKey: "number") as! String
        build  = aDecoder.decodeObject(forKey: "build") as! String
        launchNumber = aDecoder.decodeInteger(forKey: "launchNumber")
        firstLaunchDate = aDecoder.decodeObject(forKey: "firstLaunchDate") as! Date
        os_version = aDecoder.decodeObject(forKey: "os_version") as! String
    }
    override var description: String {
        get {
            return "\(["number":number, "build":build, "launchNumber":launchNumber, "firstLaunchDate" : firstLaunchDate , "os_version":os_version])"
        }
    }
    
}

class CurrentVersion: AppVersion {
    override init(_ withNumber: String, build: String, launchNumber: Int) {
        super.init(withNumber, build: build, launchNumber: launchNumber)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    lazy var PrevVersion : AppVersion? = {
        let a = Versioner.SavedVersions
        if a.count > 1 {
            if let i = a.index(of: self) {
                return a[i - 1]
            }
        }
        return nil
    }()
    
    @discardableResult
    /// Denots to :
    /// # App was not installed before this version
    /// or # App was installed but this library was not included in previous version
    ///
    /// - Parameter handler: success closure
    /// - Returns: self for method chaining
    func isFreshInstall (handler:()->Void) -> CurrentVersion {
        if PrevVersion == nil , launchNumber == 1 {
            handler()
        }
        return self
    }
    
    @discardableResult
    /// Denots to :
    /// # (App was installed before) and (this version has number newer than previous one and launched for the first time)
    ///
    /// - Parameter handler: success closure
    /// - Returns: self for method chaining
    func isUpdate (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
        
        if let prev = PrevVersion , launchNumber == 1 {
            if prev < self {
                handler(prev)
            }
        }
        return self
    }
    @discardableResult
    /// Denots to :
    /// # (App was installed before) and (this version has number older than previous one and launched for the first time)
    ///
    /// - Parameter handler: success closure
    /// - Returns: self for method chaining
    func isDowngrade (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
        
        if let prev = PrevVersion , launchNumber == 1 {
            if prev > self {
                handler(prev)
            }
        }
        return self
    }
    @discardableResult
    /// # App Launched with launch number = launchNumber
    ///
    /// - Parameters:
    ///   - launchNumber:
    ///   - handler: success closure
    /// - Returns: self for method chaining
    func isLaunch (number launchNumber:Int, handler:()->Void) -> CurrentVersion {
        if self.launchNumber == launchNumber {
            handler()
        }
        return self
    }
    @discardableResult
    /// Denots to :
    /// # (App was installed before) and (this version has build number newer than previous one and launched for the first time)
    ///
    /// - Parameter handler: success closure
    /// - Returns: self for method chaining
    func isBuildUpdate (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
        if launchNumber == 1, let prev = PrevVersion {
            if prev == self , self.build.compare(prev.build, options: .numeric) == .orderedDescending {
                handler(prev)
            }
        }
        return self
    }
    @discardableResult
    /// Denots to :
    /// # (App was installed before) and (this version has build number older than previous one and launched for the first time)
    ///
    /// - Parameter handler: success closure
    /// - Returns: self for method chaining
    func isBuildDowngrade (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
        if launchNumber == 1, let prev = PrevVersion {
            if prev == self , self.build.compare(prev.build, options: .numeric) == .orderedAscending {
                handler(prev)
            }
        }
        return self
    }
}
/*
 AppVersion comparision operators
 */
func > (left: AppVersion, right: AppVersion) -> Bool {
    return left.number.compare(right.number, options: .numeric) == .orderedDescending
}
func == (left: AppVersion, right: AppVersion) -> Bool {
    return left.number.compare(right.number, options: .numeric) == .orderedSame
}
func != (left: AppVersion, right: AppVersion) -> Bool {
    return [ComparisonResult.orderedAscending,.orderedDescending].contains(left.number.compare(right.number, options: .numeric))
}
func < (left: AppVersion, right: AppVersion) -> Bool {
    return left.number.compare(right.number, options: .numeric) == .orderedAscending
}
func <= (left: AppVersion, right: AppVersion) -> Bool {
    return left < right || left == right
}
func >= (left: AppVersion, right: AppVersion) -> Bool {
    return left > right || left == right
}
