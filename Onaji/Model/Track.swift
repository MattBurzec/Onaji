//
//  Track.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/30/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import Foundation

struct Track {
    var name: String
    var identifier : String
    var playableUri: URL
    
    init(track: SPTPartialTrack) {
        self.name = track.name
        self.identifier = String(track.identifier)
        self.playableUri = track.playableUri
    }
    
}
