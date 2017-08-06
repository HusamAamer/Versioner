//
//  ViewController.swift
//  Versioner
//
//  Created by ababel2007@yahoo.com on 08/05/2017.
//  Copyright (c) 2017 ababel2007@yahoo.com. All rights reserved.
//

import UIKit
import Versioner

class ViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var version_info_title: UILabel!
    @IBOutlet weak var details: UILabel!
    var ui_updated : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get current version
        let current_version = Versioner.currentVersion
        
        // For example beauty
        let launchesNumber = current_version.launchNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let styled_launchesNumber = formatter.string(from: NSNumber.init(value: launchesNumber))!
        let welcoming_string = "This is your \(styled_launchesNumber) visit 😃"
        
        
        ////////////////////////////////////////////////////////////
        // :: BEFORE NEXT CODE ::
        //      You should add Versioner.initiate() to
        //    didFinishLaunchingWithOptions in AppDelegate.swift
        ////////////////////////////////////////////////////////////
        
        
        ////////////////////////////////////////////////////////////
        // :: Usage #1 => at current version state do something cool
        ////////////////////////////////////////////////////////////
        Versioner.currentVersion.isFreshInstall {
            /*
             🔸 App first launch ever
                 - App was not installed before this version
                 or - App was installed but this library was not included in previous versions
             */
            updateUI(set: "Welcome 🙏🏻",
                     subtitle: welcoming_string,
                     details: current_version)
            
        }.isUpdate { (prevVersion) in
            
            /*
             🔸 Update opened
                - (App was installed before) and (this version has a number newer than previous one and launched for the first time)
             */
            updateUI(set: "Updated successfully ✅",
                     subtitle: welcoming_string,
                     version_info: "Previous version info",
                     details: prevVersion)
        }.isDowngrade { (prevVersion) in
            
            // 🔸 Old version launched
            updateUI(set: "🙁",
                     subtitle: "Please get me back to the newer version",
                     version_info: "Previous version info",
                     details: prevVersion)
            
            
        }.isLaunch(number: 3) {
            /*
             🔸 Launch number X of this version (not all versions together),
                        X = any number you want */
            updateUI(set: "Third Welcome is special ❤️",
                     subtitle: welcoming_string,
                     details: current_version)
        }.isBuildUpdate { (prevVersion) in
            /*
             🔸 New build launched with same previous version number */
            updateUI(set: "Welcome tester",
                     subtitle: "I'm the newest build",
                     version_info: "Previous version info",
                     details: prevVersion)
        }.isBuildDowngrade(handler: { (prevVersion) in
            /*
             🔸 Old build launched with same previous version number */
            updateUI(set: "YOU, Don't play with my build !!",
                     subtitle: welcoming_string,
                     version_info: "Previous version info",
                     details: prevVersion)
        })
        
        // If nothing of the above changed the UI
        if !ui_updated {
            updateUI(set: "Welcome back!",
                     subtitle: welcoming_string,
                     details: current_version)
        }
        
        
        
        
        
        
        
        
        
        ////////////////////////////////////////////////////////////
        // :: Usage #2 => Execute specific code depening on app version
        ////////////////////////////////////////////////////////////
        if Versioner.currentVersion > AppVersion("3.0") {
            // Do new code
            //      ex: call new backend
        } else {
            // Do old code
            //      ex: call old backend
        }
        
        
        
        
        
        
        
        
        
        ////////////////////////////////////////////////////////////
        // :: Usage #3 => Version number comparision operators
        ////////////////////////////////////////////////////////////
        print(Versioner.currentVersion > AppVersion("3.0.0.1")) // true or false
        print(AppVersion("3.0") < AppVersion("3.1")) // true
        print(AppVersion("3.0") == AppVersion("3.0")) // true
    }
    
    
    
    
    
    /// Updates Example app Labels in Main.storyboard
    ///
    private func updateUI (set title:String,
                           subtitle:String,
                           version_info:String = "Current version info ",
                           details:AppVersion) {
        self.titleLbl.text = title
        self.subtitle.text = subtitle
        self.version_info_title.text = version_info
        
        self.details.text = "Version : \(details.number) build \(details.build)\n"
        self.details.text?.append("Launched \(details.launchNumber) time(s)\n")
        self.details.text?.append("First launch : \(details.firstLaunchDate)\n")
        self.details.text?.append("First installed os version : \(details.os_version)\n")
        
        ui_updated = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

