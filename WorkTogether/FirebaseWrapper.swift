//
//  FirebaseWrapper.swift
//  WorkTogether
//
//  Created by amazin on 3/10/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation
import Firebase

class FirebaseWrapper {
    
    struct Refs {
        static let baseRef = Firebase(url: "https://worktogether.firebaseio.com")
        static let allUsersRef = Firebase(url: "https://worktogether.firebaseio.com/users")
        static let roomsRef = Firebase(url: "https://worktogether.firebaseio.com/rooms")
        static let drawingsRef = Firebase(url: "https://worktogether.firebaseio.com/drawings")
        static let roomCodeRef = Firebase(url: "https://worktogether.firebaseio.com/roomcodes")
    }
    
    func authEventListener(ref: Firebase!, completionHandler: ((FAuthData!) -> Void)!) {
        ref.observeAuthEventWithBlock(completionHandler)
    }
    
    func observeValueEventWithRef(ref: Firebase!, completionHanlder: ((FDataSnapshot!) -> Void)!) {
        ref.observeEventType(.Value, withBlock: completionHanlder)
    }
    
    func observeChildAddedEventWithRef(ref: Firebase!, completionHanlder: ((FDataSnapshot!) -> Void)!) {
        ref.observeEventType(.ChildAdded, withBlock: completionHanlder)
    }
    
    func observeSingleEventWithRef(ref: Firebase!, completionHanlder: ((FDataSnapshot!) -> Void)!) {
        ref.observeSingleEventOfType(.Value, withBlock: completionHanlder)
    }
    
    func setValueWithRef(ref: Firebase!, value:AnyObject) {
        ref.setValue(value)
    }
    
    func updateValueWithRef(ref: Firebase!, value:AnyObject) {
        ref.updateChildValues(value as! [NSObject : AnyObject])
    }
    
    func roomCodeExistInCloud(roomCode: String) -> Bool {
        var exist = false
        Refs.roomCodeRef.queryOrderedByValue().queryEqualToValue(roomCode).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value != nil {
                exist = true
            } else {
                exist = false
            }
        })
        return exist
    }
    
    func findRoomBasedOnRoomCodeInCloud(roomCode: String) -> Room? {
        var room: Room?
       
        return room
    }
 
}

//if authData != nil {
//    
//    ref.observeEventType(.Value, withBlock: { (snapshot) -> Void in
//        for aUser in snapshot.children {
//            let user = User(snapshot: aUser as! FDataSnapshot)
//            self.users.append(user)
//        }
//        self.tableView.reloadData()
//    })
//}