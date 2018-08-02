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
    var artist: String
    
    init(track: SPTPartialTrack) {
        self.name = track.name
        self.identifier = String(track.identifier)
        self.playableUri = track.playableUri
        
        let artistPartials = track.artists as! [SPTPartialArtist]
        let artists = artistPartials.map { (aPartialArtist) -> String in
            return aPartialArtist.name
        }
            self.artist = artists.joined(separator: ", ")
    }
}

extension Track: Equatable {
    
    public static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

