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
    
    let cloud = FirebaseWrapper()
    var rooms = [Room]()
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(user.uid).childByAppendingPath("rooms").observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            for snapChild in snapshot.children.allObjects as! [FDataSnapshot]{
            
                FirebaseWrapper.Refs.roomsRef.childByAppendingPath(snapChild.value as! String).observeSingleEventOfType(.Value, withBlock: {snapshot in
                    let roomName = snapshot.value["roomName"] as! String
                    let hostUser = snapshot.value["hostUser"] as! String
                    self.rooms.append(Room(roomName: roomName, hostUser: hostUser))
                    self.tableView.reloadData()
                })
            }
            
        })         // join
        //        cloud.observeValueEventWithRef(FirebaseWrapper.Refs.roomsRef) { (_) -> Void in
        //            if self.user != nil {
        //                self.cloud.updateValueWithRef(FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(self.user.uid).childByAppendingPath("rooms"), value: [self.room.roomCode: true])
        //                 print("2")
        //            }
        //        }
        //
        //        cloud.observeValueEventWithRef(FirebaseWrapper.Refs.roomCodeRef) { (snapshot) -> Void in
        //            self.codes = []
        //            for code in snapshot.children {
        //                if let key = code.key {
        //                    self.codes.append(key!)
        //                }
        //            }
        //             print("3")
        //        }
        //
    }
    
    override func viewDidDisappear(animated: Bool) {
        rooms.removeAll()
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
        let alertController = UIAlertController(title: "Enter Room Name", message: "Please enter room name", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (roomNameTextField) in
            roomNameTextField.placeholder = "Room Name"
        }
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            if let textField = alertController.textFields?.first {
                if textField.text != "" {
                    let room = Room(roomName: textField.text!, hostUser: self.user.name)
                    let createRoomAlertController = UIAlertController(title: "Create Successful", message: "Your room ID is \" \(room.roomCode) \", tell your coworkers to join this room", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel) { (_) -> Void in
                        self.cloud.setValueWithRef(FirebaseWrapper.Refs.roomsRef.childByAppendingPath(room.roomCode), value: room.serializeToDictionary())
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
                        self.cloud.observeSingleEventWithRef(FirebaseWrapper.Refs.roomsRef.childByAppendingPath(code), completionHanlder: { (snapshot) -> Void in
                            FirebaseWrapper.Refs.roomsRef.childByAppendingPath(code).observeSingleEventOfType(.Value, withBlock: {snapshot in // update cloud
                                var room = Room(dictionary: snapshot.value as! [String: AnyObject])
                                room.members.append(self.user.name)
                                FirebaseWrapper.Refs.roomsRef.childByAppendingPath(code).setValue(room.serializeToDictionary())
                                FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(self.user.uid).childByAppendingPath("rooms").childByAutoId().setValue(code)
                                self.rooms.append(room)
                                self.performSegueWithIdentifier("RoomMembersViewController", sender: nil)
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
                        if let newRoom = rooms.last {
                            roomMembersViewController.room = newRoom
                            print("-->roomcode \(newRoom)")
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
