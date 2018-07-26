//
//  User.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/23/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import Foundation

struct User {
    static func isUserAlreadyLoggedIn() -> Bool {
        let userDefaults = UserDefaults.standard
        guard let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject?,
            let sessionDataObj = sessionObj as? Data,
            let _ = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession else {
                return false
            }
        return true
    }
}
