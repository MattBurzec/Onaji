//
//  AddUserViewController.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/24/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    var session: SPTSession?
//    session = ds
    
    @IBOutlet weak var addUsernameLabel: UILabel!
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourTextField: UITextField!
    
    @IBOutlet weak var secondPlus: UIButton!
    @IBOutlet weak var thirdPlus: UIButton!
    

    @IBOutlet weak var playlistTextField: UITextField!
    
    
    @IBAction func addUsernameButton(_ sender: Any) {
        secondTextField.isHidden = false
        secondPlus.isHidden = false
    }
    @IBAction func secondAddUsernameButton(_ sender: Any) {
        thirdTextField.isHidden = false
        thirdPlus.isHidden = false
    }
    @IBAction func thirdAddUsernameButton(_ sender: Any) {
        fourTextField.isHidden = false
    }
    @IBAction func continueButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callSession()
        getPlaylists()
    }        // Do any additional setup after loading the view}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callSession() {
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = currentSession
        }
        
    }
    
    func getPlaylists() {
        //  todo: set user to current user
        // TODO: safely unwrap access token
        
        
        SPTPlaylistList.playlists(forUser: "kickassswagster", withAccessToken: session!.accessToken!) { (error, data) in
            if let error = error {
                print("\nFound error: \(error)\n")
                return
            }
            
            let playlists = data as! SPTPlaylistList
            print(playlists.totalListLength)
            for i in playlists.items {
                print(i)
            }
            
            
//            let play = data as! SPTPlaylistTrack
//            print(play.identifier)
//            
            // cast into array of partial playlists
            // get the id of each partial playlist
            // get playlist snapshot for each id
            // get tracks for each snapshot
        }

    }
 
    var userPlaylists = [SPTPartialPlaylist]()
    
}
