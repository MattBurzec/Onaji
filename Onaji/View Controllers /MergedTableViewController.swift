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
    func getTracks(  completion: @escaping([Track])-> ()) {
        guard let session = SpotifyHelper.session else {
            return
        }
        
        //Mark: Getting Tracks From Playlist
        for playlist in listPlaylist {
            
            SPTPlaylistSnapshot.playlist(withURI: playlist.uri, accessToken: session.accessToken) { (error, data) in
                guard let snapshot = data as? SPTPlaylistSnapshot else {
                    return assertionFailure("User logged out")
                }
                 //get the first page
                guard let firstPage = snapshot.firstTrackPage else {
                    return
                }
                let selectedTracks = firstPage.items as? [SPTPartialTrack]
                var arrayOfTrack = [Track]()
                for track in selectedTracks! {
                    let newTrack = Track(track: track)
                    arrayOfTrack.append(newTrack)
                }
//                print(firstPage.items)
                completion(arrayOfTrack)
            }
    
        }
    }

    //Mark: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
            playlistNameLabel.text = playlistNameText
        getTracks { tracks in
            self.sortingTracks(arrayOfTracks: tracks)
        }
    }
    
    func sortingTracks(arrayOfTracks: [Track]) {
        var sortedArray = arrayOfTracks
        
        
        
        
        
        
        
        
        
        self.currentTracks = sortedArray
        self.tableView.reloadData()
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

