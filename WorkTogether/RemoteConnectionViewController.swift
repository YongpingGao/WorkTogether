//
//  RemoteConnectionViewController.swift
//  WorkTogether
//
//  Created by amazin on 3/8/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit

class RemoteConnectionViewController: UITableViewController, RoomCodeGeneratorDelegate {

    var rooms: [Room] = []
    let roomCodeGenerator = RoomCodeGenerator()
    override func viewDidLoad() {
        super.viewDidLoad()
        roomCodeGenerator.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createRoom(sender: AnyObject) {
        
        let alertViewController = UIAlertController(title: "Start Working", message: "Create or Join a room", preferredStyle: .Alert)
        
        let createAction = UIAlertAction(title: "Create a room", style: .Default) { (_) -> Void in
           self.createRoomSuccessfulAlert()
        }
        
        let joinAction = UIAlertAction(title: "Join a room", style: .Default) { (_) -> Void in
            self.joinRoomAlert()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertViewController.addAction(createAction)
        alertViewController.addAction(joinAction)
        alertViewController.addAction(cancelAction)
        
        presentViewController(alertViewController, animated: true, completion: nil)
        
    }
    
    private func createRoomSuccessfulAlert() {
        
        let roomCode = roomCodeGenerator.randomCodeString
        let createRoomAlertController = UIAlertController(title: "Create a room", message: "Your room ID is \" \(roomCode) \", tell your coworkers to join this room", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) { (_) -> Void in
            
            
            // TODO: - CLOUD
            let room = Room(r_id:"001", hostUser:User(uid: "aa", name: "aa", email: "aa"), members: [User(uid: "aa", name: "aa", email: "aa")], exists: true, roomCode: roomCode)
            self.rooms.append(room)
            self.tableView.reloadData()
            
            self.performSegueWithIdentifier("CreateRoomSegue", sender: nil)
        }
        createRoomAlertController.addAction(okAction)
        
        
        
        
        presentViewController(createRoomAlertController, animated: true, completion: nil)

    }
    
    
    private func joinRoomAlert() {
        let joinRoomAlertController = UIAlertController(title: "Join a room", message: "Enter the room code from room owner", preferredStyle: .Alert)
        
        joinRoomAlertController.addTextFieldWithConfigurationHandler { (textCode) -> Void in
            textCode.placeholder = "Enter room code"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
            if let textField = joinRoomAlertController.textFields {
                let codeField = textField[0]
                if let code = codeField.text {
                    print("Check if \(code) is valide!!")
                    
                    // TODO: - CLOUD from cloud Check if \(code) is valide
                    // if yes -> add a room member
                    
                    if true {
                        // go to cloud -> find room id -> add a new user
                        let room = Room(r_id:"002", hostUser:User(uid: "aa", name: "aa", email: "aa"), members: [User(uid: "bb", name: "bb", email: "bb")], exists: true, roomCode: code)
                        self.rooms.append(room)
                        self.tableView.reloadData()
                        self.performSegueWithIdentifier("CreateRoomSegue", sender: nil)
                    }
                    // if no -> alert!
                }
            }
        }
        
        joinRoomAlertController.addAction(okAction)
        
        presentViewController(joinRoomAlertController, animated: true, completion: nil)
    }
    
    func didFinishGenerateRoomCode(roomCode: String) -> Bool {
        //TODO: - If roomCode is not in cloud
        return true
        
    }
    
    @IBAction func backToRemoteConection(segue: UIStoryboardSegue, sender: UIBarButtonItem){}
    
    
    // MARK: - Tableview Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RoomCell", forIndexPath: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].roomCode
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
}
