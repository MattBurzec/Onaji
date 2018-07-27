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
    
    @IBOutlet weak var button: DropDownBtn!
    @IBOutlet weak var playlistTwo: DropDownBtn!
    @IBOutlet weak var playlistThree: DropDownBtn!
    @IBOutlet weak var playlistFour: DropDownBtn!
    
    @IBOutlet weak var addUsernameLabel: UILabel!
    
    
    @IBOutlet weak var secondPlus: UIButton!
    @IBOutlet weak var thirdPlus: UIButton!
    

    @IBOutlet weak var playlistTextField: UITextField!
    
    
    @IBAction func addUsernameButton(_ sender: Any) {
        playlistTwo.isHidden = false
        secondPlus.isHidden = false
    }
    @IBAction func secondAddUsernameButton(_ sender: Any) {
        playlistThree.isHidden = false
        thirdPlus.isHidden = false
    }
    @IBAction func thirdAddUsernameButton(_ sender: Any) {
        playlistFour.isHidden = false
    }
    @IBAction func continueButton(_ sender: Any) {
    }
    
    
    
    
    
    
    
    func callSession() {
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = currentSession
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callSession()
        getPlaylists()
        
        button = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("Playlist", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.dropView.dropDownOption = ["World", "Hello"]
        
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
            //          print(playlists.totalListLength)
            for i in playlists.items {
                // print(i)
                let item = i as! SPTPartialPlaylist
                //                print(item.name)
//                let playlistNames = item.name
                
                let playlistInfo = Playlist(playlist: item)
                print(playlistInfo)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callSession()
        getPlaylists()
        button.dropView.dropDownOption = ["Good", "Morning"]
        playlistTwo.dropView.dropDownOption = ["Hi", "Fop"]
        playlistThree.dropView.dropDownOption = ["Kobe", "Jordan"]
        playlistFour.dropView.dropDownOption = ["lemonade", "animals"]
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


protocol dropDownProtocol {
    func dropDownPressed(string: String)
}

class DropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
                
                
            }, completion: nil)
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
      
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOption = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.blue
        self.backgroundColor = UIColor.blue
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor.blue
        
        cell.textLabel?.text = dropDownOption[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOption[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




























// TODO: only call this for thep playlists that user specifies
//                SPTPlaylistSnapshot.playlist(withURI: item.uri!, accessToken: self.session!.accessToken!, callback: { (error, data) in
//                    if let error = error {
//                        print("\nFound error: SPTPlaylistsnapshot \(error)\n")
//                        return
//                    }
//                    let snapshot = data as! SPTPlaylistSnapshot
////                    print(snapshot.descriptionText)
//
//                })




//                SPTTrack.tracks(withURIs: [item.uri], accessToken: self.session!.accessToken!, market: nil!, callback: { (error, data)  in
//                        if let error = error {
//                            print("\nFound error: \(error)\n")
//                            return
//
//                        let track = data as! SPTTrack
//                        print(track.trackNumber)




//                   let snapshot = data as! SPTPlaylistSnapshot
//                    print(snapshot.playableUri)



//                    let tracks = playlistSnapshot.firstTrackPage as! SPTListPage
//
//                    for item in tracks.items {
//                        let track = item as! SPTPartialTrack
//                        print(track)
//                    }




//                SPTTrack.tracks(withURIs: [item.uri], accessToken: self.session!.accessToken!, market: nil, callback: { (error, data) in
//                    let tracks = data as! [SPTTrack]
//                    print(tracks)
//                })


// cast into array of partial playlists
// get the id of each partial playlist
// get playlist snapshot for each id
// get tracks for each snapshot
