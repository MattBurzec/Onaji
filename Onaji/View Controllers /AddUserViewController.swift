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
    
    //Mark: Playlist Button
    @IBOutlet weak var button: DropDownBtn!
    @IBOutlet weak var playlistTwo: DropDownBtn!
    @IBOutlet weak var playlistThree: DropDownBtn!
    @IBOutlet weak var playlistFour: DropDownBtn!
    
    @IBOutlet weak var addUsernameLabel: UILabel!
    
    
    @IBOutlet weak var secondPlus: UIButton!
    @IBOutlet weak var thirdPlus: UIButton!
    
    //Mark: Button Variables
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
    
    
    // array of track
    var myPlayList = [Playlist]() {
        didSet {
            
            //update all of the drop down buttons with the new value
            let arrayOfPlaylistTitles = myPlayList.map { (aPlistlist) -> String in
                return aPlistlist.title
            }
            
            button.dropView.dropDownOption = arrayOfPlaylistTitles
            button.dropView.tableView.reloadData()
            playlistTwo.dropView.dropDownOption = arrayOfPlaylistTitles
            playlistTwo.dropView.tableView.reloadData()
            playlistThree.dropView.dropDownOption = arrayOfPlaylistTitles
            playlistThree.dropView.tableView.reloadData()
            playlistFour.dropView.dropDownOption = arrayOfPlaylistTitles
            playlistFour.dropView.tableView.reloadData()
            
        }
    }

   
    
    
    //Mark: Identifying Button Selection
    @IBAction func continueButton(_ sender: Any) {
        
        //[button.title(for: .normal), playlistTwo.title(for: .normal), playlistThree.title(for: .normal), playlistFour.title(for: .normal)]
        
        var arrayOfPlaylist: [Playlist] = []
        
        if let selectedRowForPlaylist1 = button.selectedRow {
            let selectedPlaylist1: Playlist = self.myPlayList[selectedRowForPlaylist1]
            arrayOfPlaylist.append(selectedPlaylist1)
        }
        
        if let selectedRowForPlaylist2 = playlistTwo.selectedRow {
            let selectedPlaylist2: Playlist = self.myPlayList[selectedRowForPlaylist2]
            arrayOfPlaylist.append(selectedPlaylist2)
        }
        
        if let selectedRowForPlaylist3 = playlistThree.selectedRow {
            let selectedPlaylist3: Playlist = self.myPlayList[selectedRowForPlaylist3]
            arrayOfPlaylist.append(selectedPlaylist3)
        }
        
        if let selectedRowForPlaylist4 = playlistFour.selectedRow {
            let selectedPlaylist4: Playlist = self.myPlayList[selectedRowForPlaylist4]
            arrayOfPlaylist.append(selectedPlaylist4)
        }
        
        
        self.performSegue(withIdentifier: "sendPL", sender: arrayOfPlaylist)
    }
    
    
    // MARK: Segue to MergeVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sendPL"{
            let pl = sender as! [Playlist]
            let mergeVC = segue.destination as! MergedTableViewController
            
            mergeVC.listPlaylist = pl
            print(mergeVC.listPlaylist)
            
            let DestViewController : MergedTableViewController = segue.destination as! MergedTableViewController
            DestViewController.playlistNameText = self.playlistTextField.text!
        }
    }
    
    //Mark Calling Session
    func callSession() {
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = currentSession
        }
        
    }
    
    //Mark: Getting Playlist Information
    func getPlaylists(  completion: @escaping([Playlist])-> ()) {
        //  todo: set user to current user
        // TODO: safely unwrap access token
        
        
        SPTPlaylistList.playlists(forUser: "kickassswagster", withAccessToken: session!.accessToken!) { (error, data) in
            if let error = error {
                print("\nFound error: \(error)\n")
                return
            }
            var playL = [Playlist]()
            let playlists = data as! SPTPlaylistList
            // print(playlists.totalListLength)
            
            //convert into Model
            for i in playlists.items {
                // print(i)
                guard let partialPlaylist = i as? SPTPartialPlaylist else {
                    fatalError("wow")
                }
                
                let newPL = Playlist(playlist: partialPlaylist)
                playL.append(newPL)
            }
            
            completion(playL)
        }
    }
    
    //Mark: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        callSession()
        
        let myCOmpletionWhenPlaylistsIsDone: ([Playlist]) -> () = { (myPL) in
            self.myPlayList = myPL
            
        }
        getPlaylists(completion: myCOmpletionWhenPlaylistsIsDone)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}





//Mark: DropDownBar Implementation
protocol dropDownProtocol {
    func dropDownPressed(rowNumber: Int, string: String)
}

class DropDownBtn: UIButton, dropDownProtocol {
    
    var selectedRow: Int?
    
    func dropDownPressed(rowNumber: Int, string: String) {
        self.setTitle(string, for: .normal)
        self.selectedRow = rowNumber
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
        guard superview != nil else { return }
        
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
        self.delegate.dropDownPressed(rowNumber: indexPath.row, string: dropDownOption[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

