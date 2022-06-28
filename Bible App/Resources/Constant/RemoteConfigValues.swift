//
//  RemoteConfigValues.swift
//  Bible App
//
//  Created by Kavita Thorat on 14/05/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
import Firebase

enum ValueKey: String {
    case panel
    case tutorial_type
}


class RemoteConfigValues {
    
    static let sharedInstance = RemoteConfigValues()
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    
    private init() {
        //loadDefaultValues()
        
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
           // ValueKey.panel.rawValue: "",
            ValueKey.tutorial_type.rawValue: "",
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchCloudValues() {
        // WARNING: Don't actually do this in production!
        let fetchDuration: TimeInterval = 5
//        activateDebugMode()
        print("fetch start" + "\(Date())")
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) {
            [weak self] (status, error) in
            
            if let error = error {
                print ("Uh-oh. Got an error fetching remote values \(error)")
                self?.fetchComplete = true
                self?.loadingDoneCallback?()
                // In a real app, you would probably want to call the loading done callback anyway,
                // and just proceed with the default values. I won't do that here, so we can call attention
                // to the fact that Remote Config isn't loading.
                return
            }
            print("fetch complete" + "\(Date())")
            print(RemoteConfigValues.sharedInstance.string(forKey: .tutorial_type))
            if RemoteConfigValues.sharedInstance.string(forKey: .tutorial_type) != "" {
                self?.fetchComplete = true
                self?.loadingDoneCallback?()
            } else {
                RemoteConfig.remoteConfig().activate { (error) in
                    if error == nil {
                        //                print("activate complete" + "\(Date())")
                        //                print(RemoteConfigValues.sharedInstance.string(forKey: .panel))
                        //
                        print ("Retrieved values from the cloud!")
                        self?.fetchComplete = true
                        self?.loadingDoneCallback?()
                    } else {
                        print("activate complete with error" + "\(Date())" + error!.localizedDescription)
                        
                    }
                }
            }
        }
    }
    
    func activateDebugMode() {
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        RemoteConfig.remoteConfig().configSettings = debugSettings
        
    }
    
    //  func color(forKey key: ValueKey) -> UIColor {
    //    let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFFFF"
    //    let convertedColor = UIColor(colorAsHexString)
    //    return convertedColor
    //  }
    
    func bool(forKey key: ValueKey) -> Bool {
        return RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func string(forKey key: ValueKey) -> String {
        return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    func int(forKey key: ValueKey) -> Int {
        return RemoteConfig.remoteConfig()[key.rawValue].numberValue?.intValue ?? 0
    }
    
    func double(forKey key: ValueKey) -> Double {
        if let numberValue = RemoteConfig.remoteConfig()[key.rawValue].numberValue {
            return numberValue.doubleValue
        } else {
            return 0.0
        }
    }
}
