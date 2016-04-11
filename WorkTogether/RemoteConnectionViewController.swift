//
//  RemoteConnectionViewController.swift
//  WorkTogether
//
//  Created by amazin on 3/8/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit
import Firebase
// user's all rooms
class RemoteConnectionViewController: UITableViewController {
    
    // MARK: - Propertires
    let cloud = FirebaseWrapper()
    var rooms = [Room]()
    var user: User!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rooms.removeAll()
        // load all rooms of current user from cloud
        FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(user.uid).childByAppendingPath("rooms").observeSingleEventOfType(.Value, withBlock: { snapshot in
            for snapChild in snapshot.children.allObjects as! [FDataSnapshot] {
                FirebaseWrapper.Refs.roomsRef.childByAppendingPath(snapChild.value as! String).observeSingleEventOfType(.Value, withBlock: {snapshot in
                    if let room = self.cloud.findRoomBasedOnSnapshot(snapshot) {
                        self.rooms.append(room)
                    } else {
                        print("can't find room")
                    }
                    self.tableView.reloadData()
                })
            }
            
           
        })
    }
    
    // MARK: - Create or Join a room
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
        let alertController = UIAlertController(title: "Enter Room Name", message: "Please enter room name", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (roomNameTextField) in
            roomNameTextField.placeholder = "Room Name"
        }
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            if let textField = alertController.textFields?.first {
                if textField.text != "" {
                    let room = Room(roomName: textField.text!, hostUser: self.user.uid)
                    room.members.append(self.user.name)
                    let createRoomAlertController = UIAlertController(title: "Create Successful", message: "Your room ID is \" \(room.roomCode) \", tell your coworkers to join this room", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel) { (_) -> Void in
                        FirebaseWrapper.Refs.roomsRef.childByAppendingPath(room.roomCode).setValue(room.serializeToDictionary())
                        FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(self.user.uid).childByAppendingPath("rooms").childByAutoId().setValue(room.roomCode)
                        FirebaseWrapper.Refs.roomCodeRef.childByAutoId().setValue(room.roomCode)
                        self.rooms.append(room)
                        self.tableView.reloadData()
                        self.performSegueWithIdentifier("RoomMembersViewController", sender: nil)
                    }
                    createRoomAlertController.addAction(okAction)
                    self.presentViewController(createRoomAlertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Warning", message: "Room Name can't be empty", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: false, completion: nil)
                }
            }
        }
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func joinRoomAlert() {
        let joinRoomAlertController = UIAlertController(title: "Join a new room", message: "Enter the room code from room owner", preferredStyle: .Alert)
        
        joinRoomAlertController.addTextFieldWithConfigurationHandler { (textCode) -> Void in
            textCode.placeholder = "Enter room code"
        }
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
            if let code = joinRoomAlertController.textFields?.first?.text {
                FirebaseWrapper.Refs.roomCodeRef.queryOrderedByValue().queryEqualToValue(code).observeEventType(.Value, withBlock: { snapshot in
                    if snapshot.exists() { // if find the room code
                        FirebaseWrapper.Refs.roomsRef.childByAppendingPath(code).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                            FirebaseWrapper.Refs.roomsRef.childByAppendingPath(code).observeSingleEventOfType(.Value, withBlock: {snapshot in // update cloud
                                if let room = self.cloud.findRoomBasedOnSnapshot(snapshot) {
                                    room.members.append(self.user.name)
                                    FirebaseWrapper.Refs.roomsRef.childByAppendingPath(code).setValue(room.serializeToDictionary())
                                    FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(self.user.uid).childByAppendingPath("rooms").childByAutoId().setValue(code)
                                    self.rooms.append(room)
                                    self.performSegueWithIdentifier("RoomMembersViewController", sender: nil)
                                } else {
                                    print("Can't find a room in the cloud")
                                }
                            })
                        })
                    } else { // can't find the room code
                        let alertController = UIAlertController(title: "Warning", message: "Can't find this room code", preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
        joinRoomAlertController.addAction(OKAction)
        presentViewController(joinRoomAlertController, animated: true, completion: nil)
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RoomMembersViewController" {
            if let splitViewController = segue.destinationViewController as? UISplitViewController {
                if let navigationController = splitViewController.viewControllers.first as? UINavigationController {
                    if let roomMembersViewController = navigationController.topViewController as? RoomMembersViewController {
                        if let navigationControllerDrawing = splitViewController.viewControllers.last as? UINavigationController {
                            if let drawingViewController = navigationControllerDrawing.topViewController as? DrawingViewController {
                                if let row = tableView.indexPathForSelectedRow?.row {
                                    roomMembersViewController.room = rooms[row] // if select a specific row
                                    drawingViewController.room = rooms[row] // if select a specific row
                                    
                                    if user.uid == rooms[row].hostUser {
                                        drawingViewController.userInteractionEnabled = true
                                    }
                                    
                                } else {
                                    roomMembersViewController.room = rooms.last // else triggered automatically
                                    drawingViewController.room = rooms.last // else triggered automatically
                                    
                                    if user.uid == rooms.last!.hostUser {
                                        drawingViewController.userInteractionEnabled = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

 
    
    @IBAction func backToRemoteConection(segue: UIStoryboardSegue, sender: UIBarButtonItem){}
    
    // MARK: - Tableview Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RoomCell", forIndexPath: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].roomName
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
}
