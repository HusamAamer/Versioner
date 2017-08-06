//
//  AppVersioning.swift
//  Repo
//
//  Created by Husam Aamer on 8/3/17.
//  Copyright © 2017 FH. All rights reserved.
//

import UIKit

fileprivate enum AVConst {
    /// Dictionary of versions
    static let AV_DefaultsKey = "_AV_AppVersions"
    
    /// Return current app version
    static var v_CFBundleShortVersionString : String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        }
    }
    
    /// Returns current build number
    static var v_kCFBundleVersionKey : String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        }
    }
}


public class Versioner: NSObject {
    /// UserDefaults short approache
    private static var defaults  = UserDefaults.standard
    
    public static var SavedVersions : [AppVersion] = loadSavedVersions()
    
    public static var currentVersion : CurrentVersion {
        get {
            if let s = SavedVersions.last {
                return CurrentVersion.init(s.number, build: s.build, launchNumber: s.launchNumber)
            }
            fatalError("You must call Versioner.initiate() before accessing currentVersion")
        }
    }
    
    /*
            In class init we check whether current app version registered
        and increase app run_count
    */
    override init() {
        super.init()
    }
    class public func initiate () {
        
        if let lastSavedV = SavedVersions.last {
            
            // (current_version_and_build == last saved version and build) => not first run
            if AVConst.v_CFBundleShortVersionString.compare(lastSavedV.number, options: .numeric) == .orderedSame ,
                AVConst.v_kCFBundleVersionKey.compare(lastSavedV.build, options: .numeric) == .orderedSame {
                registerAppRun()
                return
            }
        }
        
        registerThisVersion()
    }
    
    /* 
            Save current version number with info in UserDefaults
     */
    private static func registerThisVersion () {
        var array = Versioner.SavedVersions
        let cur_ver = AppVersion.init(AVConst.v_CFBundleShortVersionString,
                                      build: AVConst.v_kCFBundleVersionKey)
        array.append(cur_ver)
        updateDefaults(newValue: array)
    }
    /* 
        Increase run_count of current version by one 
     */
    private static func registerAppRun () {
        var array = Versioner.SavedVersions
        if let cur_ver = array.popLast() {
            cur_ver.launchNumber = cur_ver.launchNumber + 1
            array.append(cur_ver)
        }
        updateDefaults(newValue: array)
    }
    
    /// Update UserDefaults
    ///
    /// - Parameter newValue: 
    private static func updateDefaults (newValue:[AppVersion]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
        defaults.set(data, forKey: AVConst.AV_DefaultsKey)
        defaults.synchronize()
        
        SavedVersions = loadSavedVersions()
    }
    static func loadSavedVersions () -> [AppVersion] {
        if let data = defaults.data(forKey: AVConst.AV_DefaultsKey) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as! [AppVersion]
        }
        return []
    }
}
