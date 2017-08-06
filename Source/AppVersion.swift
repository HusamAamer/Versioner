//
//  AppVersioning.swift
//  Repo
//
//  Created by Husam Aamer on 8/3/17.
//  Copyright © 2017 FH. All rights reserved.
//

import UIKit


public class AppVersion:NSObject, NSCoding {
    
    public let number          : String
    public let build           : String
    public var launchNumber    : Int
    public let firstLaunchDate : Date
    public let os_version      : String
    
    public init(_ withNumber:String, build:String = "NA", launchNumber:Int = 1) {
        self.number = withNumber
        self.build = build
        self.launchNumber = launchNumber
        self.firstLaunchDate = Date()
        self.os_version = UIDevice.current.systemVersion
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(number,           forKey: "number")
        aCoder.encode(build ,           forKey: "build")
        aCoder.encode(launchNumber ,     forKey: "launchNumber")
        aCoder.encode(firstLaunchDate , forKey: "firstLaunchDate")
        aCoder.encode(os_version ,      forKey: "os_version")
    }
    required public init?(coder aDecoder: NSCoder) {
        
        number = aDecoder.decodeObject(forKey: "number") as! String
        build  = aDecoder.decodeObject(forKey: "build") as! String
        launchNumber = aDecoder.decodeInteger(forKey: "launchNumber")
        firstLaunchDate = aDecoder.decodeObject(forKey: "firstLaunchDate") as! Date
        os_version = aDecoder.decodeObject(forKey: "os_version") as! String
    }
    override public var description: String {
        get {
            return "\(["number":number, "build":build, "launchNumber":launchNumber, "firstLaunchDate" : firstLaunchDate , "os_version":os_version])"
        }
    }
    
}

public class CurrentVersion: AppVersion {
    override public init(_ withNumber: String, build: String, launchNumber: Int) {
        super.init(withNumber, build: build, launchNumber: launchNumber)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public lazy var PrevVersion : AppVersion? = {
        let a = Versioner.SavedVersions
        if a.count > 1 {
            return a[a.count - 2]
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
    public func isFreshInstall (handler:()->Void) -> CurrentVersion {
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
    public func isUpdate (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
        
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
    public func isDowngrade (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
        
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
    public func isLaunch (number launchNumber:Int, handler:()->Void) -> CurrentVersion {
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
    public func isBuildUpdate (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
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
    public func isBuildDowngrade (handler:(_ previousVersion:AppVersion)->Void) -> CurrentVersion {
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
public func > (left: AppVersion, right: AppVersion) -> Bool {
    return left.number.compare(right.number, options: .numeric) == .orderedDescending
}
public func == (left: AppVersion, right: AppVersion) -> Bool {
    return left.number.compare(right.number, options: .numeric) == .orderedSame
}
public func != (left: AppVersion, right: AppVersion) -> Bool {
    return [ComparisonResult.orderedAscending,.orderedDescending].contains(left.number.compare(right.number, options: .numeric))
}
public func < (left: AppVersion, right: AppVersion) -> Bool {
    return left.number.compare(right.number, options: .numeric) == .orderedAscending
}
public func <= (left: AppVersion, right: AppVersion) -> Bool {
    return left < right || left == right
}
public func >= (left: AppVersion, right: AppVersion) -> Bool {
    return left > right || left == right
}
