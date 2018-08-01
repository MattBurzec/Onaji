//
//  Playlist.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/26/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import Foundation

struct Playlist {
    var title: String
    var count: String
    var uri: URL
    
    
    init(playlist: SPTPartialPlaylist) {
        self.title = playlist.name
        self.count = String(playlist.trackCount)
        self.uri = playlist.uri
        
    }
    
}
