//
//  SpotifyService.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/30/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import Foundation

struct SpotifyHelper {
    static let session: SPTSession? = {
        
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            return currentSession
            
        } else {
            return nil
        }
    }()
}
