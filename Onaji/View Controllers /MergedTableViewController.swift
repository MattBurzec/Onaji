//
//  MergedTableViewController.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/24/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import UIKit

class MergedTableViewController: UITableViewController {

    var listPlaylist = [Playlist]()
    
    
    
    func getTracks() {
        guard let session = SpotifyHelper.session else {
            return assertionFailure("user was logged out")
        }
        
        var playlistSnapshots = [SPTPlaylistSnapshot]()
        
        for playlist in listPlaylist {
            
            //get SPPlaylistSnapshot
            SPTPlaylistSnapshot.playlist(withURI: playlist.uri, accessToken: session.accessToken) { (error, data) in
                
                guard let snapshot = data as? SPTPlaylistSnapshot else {
                    return
                }
                 //get the first page
                guard let firstPage = snapshot.firstTrackPage else {
                    return
                }
                
                print(firstPage.items)
     
                
            }
        }
    }
    
    func mergePlaylistWithFirstPage(firstPage: SPTListPage, completion: @escaping (SPTListPage) -> ()) {
        guard let session = SpotifyHelper.session else {
            return assertionFailure("user was logged out")
        }
        
        if firstPage.hasNextPage {
            firstPage.requestNextPage(withAccessToken: session.accessToken, callback: { (error, data) in
                guard error == nil else {
                    fatalError()
                }
                guard let nextPage = data as? SPTListPage else {
                    fatalError()
                }
                
                firstPage.appending(nextPage)
                self.mergePlaylistWithFirstPage(firstPage: firstPage, completion: completion)
            })
        } else {
            completion(firstPage)
        }
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        
    }
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getTracks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
