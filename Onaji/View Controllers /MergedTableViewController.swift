//
//  MergedTableViewController.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/24/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import UIKit

class MergedTableViewController: UITableViewController{

    //Mark: Variables
    var listPlaylist = [Playlist]()
    var currentTracks = [Track]()
    var playlistNameText: String?
    var playlistSnapshots = [SPTPlaylistSnapshot]()
    
    
    
    //Mark: Outlets
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBAction func homeButton(_ sender: Any) {
    }
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    //Mark: Getting Tracks Call
    func getTracks(for playlists: [Playlist], completion: @escaping ([Playlist]) -> ()) {
        guard let session = SpotifyHelper.session else {
            return
        }
        
        let dg = DispatchGroup()
        
        var newFilledPlaylists = [Playlist]()
        
        //Mark: Getting Tracks From Playlist
        for playlist in playlists {
            
            dg.enter()
            
            SPTPlaylistSnapshot.playlist(withURI: playlist.uri, accessToken: session.accessToken) { (error, data) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                
                guard let snapshot = data as? SPTPlaylistSnapshot else {
                    return assertionFailure("data didn't come and no error was given")
                }
                
                 //get the first page
                guard let firstPage = snapshot.firstTrackPage else {
                    return
                }
                
                guard firstPage.hasNextPage == false else {
                    fatalError("this playlist \(playlist.title), was not downloaded completly. You must merge the pages together")
                }
                
                let selectedTracks = firstPage.items as? [SPTPartialTrack]
                var arrayOfTracks = [Track]()
                for track in selectedTracks! {
                    let newTrack = Track(track: track)
                    arrayOfTracks.append(newTrack)
                }
                
                var filledPlaylist = playlist
                filledPlaylist.tracks = arrayOfTracks
            
                newFilledPlaylists.append(filledPlaylist)
                
                dg.leave()
            }
        }
        
        
        dg.notify(queue: DispatchQueue.main) {
            completion(newFilledPlaylists)
        }
    }


    //Mark: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistNameLabel.text = playlistNameText
        getTracks(for: listPlaylist) { (newPlaylistsThatContainTracks) in
            self.currentTracks = self.applySortingAlgorithm(on: newPlaylistsThatContainTracks)
            self.tableView.reloadData()
        }
    }
    
    func applySortingAlgorithm(on playlists: [Playlist]) -> [Track] {
        
        var playlistsToPop = playlists
        var allTracks = [Track]()
        while playlistsToPop.count > 0 {
            let playlist = playlistsToPop.popLast()!
            allTracks.append(contentsOf: playlist.tracks!)
        }
        
        var histrogram: [String: Int] = [:]
        for aArack in allTracks {
            if histrogram[aArack.identifier] != nil {
                histrogram[aArack.identifier]! += 1
            } else {
                histrogram[aArack.identifier] = 1
            }
        }
        
        let keysWith4 = histrogram.compactMap({ (keyValuePair) -> String? in
            let key = keyValuePair.key
            let value = keyValuePair.value
            
            if value == 4 {
                return key
            } else {
                return nil
            }
        })
        
        let tracksWith4 = allTracks.filter { (aTrack) -> Bool in
            return keysWith4.contains(aTrack.identifier)
        }.unique
        
        let keysWith3 = histrogram.compactMap({ (keyValuePair) -> String? in
            let key = keyValuePair.key
            let value = keyValuePair.value
            
            if value == 3 {
                return key
            } else {
                return nil
            }
        })
        
        let tracksWith3 = allTracks.filter { (aTrack) -> Bool in
            return keysWith3.contains(aTrack.identifier)
        }.unique
        
        let keysWith2 = histrogram.compactMap({ (keyValuePair) -> String? in
            let key = keyValuePair.key
            let value = keyValuePair.value
            
            if value == 2 {
                return key
            } else {
                return nil
            }
        })
        
        let tracksWith2 = allTracks.filter { (aTrack) -> Bool in
            return keysWith2.contains(aTrack.identifier)
        }.unique
        
        let allOtherKeys = histrogram.compactMap({ (keyValuePair) -> String? in
            let key = keyValuePair.key
            let value = keyValuePair.value
            
            if value == 1 {
                return key
            } else {
                return nil
            }
        })
        
        let allOtherTracks = allTracks.filter { (aTrack) -> Bool in
            return allOtherKeys.contains(aTrack.identifier)
        }.unique

        return tracksWith4 + tracksWith3 + tracksWith2 + allOtherTracks
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    //MARK: Table View Data Soure

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentTracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = currentTracks[indexPath.row].name
        cell.detailTextLabel?.text = currentTracks[indexPath.row].artist
        
        
        return cell
    }
}


//        guard
//            var tracksOfFirstPlaylist = playlists[0].tracks,
//            var tracksOfSecondPlaylist = playlists[1].tracks else {
//                return []
//        }
//
//        for (_, aTrack) in tracksOfFirstPlaylist.enumerated() {
//            let isA_TrackInsideOfSecondPlaylist = tracksOfSecondPlaylist.contains(where: { (aTrackToCompare) -> Bool in
//                if aTrack.identifier == aTrackToCompare.identifier {
//                    return true
//                } else {
//                    return false
//                }
//            })
//
//            if isA_TrackInsideOfSecondPlaylist {
//                let indexOfFirstTrack = tracksOfFirstPlaylist.index { (aTrackToCompare) -> Bool in
//                    if aTrack.identifier == aTrackToCompare.identifier {
//                        return true
//                    } else {
//                        return false
//                    }
//                    }!
//                let trackToCopy = tracksOfFirstPlaylist.remove(at: indexOfFirstTrack)
//                let indexOfSecondTrack = tracksOfSecondPlaylist.index { (aTrackToCompare) -> Bool in
//                    if aTrack.identifier == aTrackToCompare.identifier {
//                        return true
//                    } else {
//                        return false
//                    }
//                }!
//                tracksOfSecondPlaylist.remove(at: indexOfSecondTrack)
//                sortedArray.append(trackToCopy)
//            }
//        }

//add the remaing tracks not found in both //        sortedArray.append(contentsOf: tracksOfFirstPlaylist)
//        sortedArray.append(contentsOf: tracksOfSecondPlaylist)
