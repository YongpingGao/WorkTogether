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
//        static let drawingsRef = Firebase(url: "https://worktogether.firebaseio.com/rooms/drawings")
        static let roomCodeRef = Firebase(url: "https://worktogether.firebaseio.com/roomcodes")
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
    
    func findRoomBasedOnSnapshot(snapshot: FDataSnapshot) -> Room? {
        if let dictionary = snapshot.value as? [String: AnyObject] {
            let roomName = dictionary["roomName"] as! String
            let hostUser = dictionary["hostUser"] as! String
            let members = dictionary["members"] as! [String]
            let roomcode = snapshot.key
            return Room(roomCode: roomcode, roomName: roomName, hostUser: hostUser, members: members)
        } else {
            return nil
        }
    
    }
}



//    func authEventListener(ref: Firebase!, completionHandler: ((FAuthData!) -> Void)!) {
//        ref.observeAuthEventWithBlock(completionHandler)
//    }
//
//    func observeValueEventWithRef(ref: Firebase!, completionHanlder: ((FDataSnapshot!) -> Void)!) {
//        ref.observeEventType(.Value, withBlock: completionHanlder)
//    }
//
//    func observeChildAddedEventWithRef(ref: Firebase!, completionHanlder: ((FDataSnapshot!) -> Void)!) {
//        ref.observeEventType(.ChildAdded, withBlock: completionHanlder)
//    }
//
//    func observeSingleEventWithRef(ref: Firebase!, completionHanlder: ((FDataSnapshot!) -> Void)!) {
//        ref.observeSingleEventOfType(.Value, withBlock: completionHanlder)
//    }
//
//    func setValueWithRef(ref: Firebase!, value:AnyObject) {
//        ref.setValue(value)
//    }
//
//    func updateValueWithRef(ref: Firebase!, value:AnyObject) {
//        ref.updateChildValues(value as! [NSObject : AnyObject])
//    }