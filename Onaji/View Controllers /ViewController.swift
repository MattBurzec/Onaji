//
//  ViewController.swift
//  Onaji
//
//  Created by Matthew  Burzec on 7/20/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
     
        
        if let url = loginUrl {
            UIApplication.shared.open(url, options: [:]) { (_) in
                if self.auth.canHandle(self.auth.redirectURL) {
                    // To do - build in error handling
                }
            }
        }
    }
    
    func setup () {
        SPTAuth.defaultInstance().clientID = "702d0e36a36a43a0a9f6334fda6371ee"
        SPTAuth.defaultInstance().redirectURL = URL(string: "Onaji://returnAfterLogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPublicScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
//        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin))
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin(_:)), name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
       
    }
    
    @objc func updateAfterFirstLogin (_ sender: Any?) {
        
        self.performSegue(withIdentifier: "ShowHome", sender: nil)
    }

        
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

