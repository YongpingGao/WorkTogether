//
//  User.swift
//  WorkTogether
//
//  Created by amazin on 3/5/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var uid:String
    var email: String
    var name: String
    var rooms: [Room]?
    var friends: [User]?
    
    init(uid: String, name: String, email: String) {
        self.uid = uid
        self.name = name
        self.email = email
        rooms = nil
        friends = nil
    }
    
    init(authData: FAuthData) {
        uid = authData.uid
        email = ""
        name = ""
//        FirebaseWrapper().observeSingleEventWithRef(FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(uid)) { (snapshot) -> Void in
//            self.init(snapshot: snapshot)
//            self.uid = snapshot.key
//            self.name = snapshot.value["name"] as! String
//            self.email = snapshot.value["email"] as! String
//            if let _groups = snapshot.value["groups"] {
//                self.rooms = _groups as? Array
//            } else {
//                self.rooms = nil
//            }
//            
//            if let  _friends = snapshot.value["friends"] {
//                self.friends = _friends as? Array
//            } else {
//                self.friends = nil
//            }
     
    }
  
    init(snapshot: FDataSnapshot) {
        uid = snapshot.key
        name = snapshot.value["name"] as! String
        email = snapshot.value["email"] as! String
        if let _groups = snapshot.value["groups"] {
            rooms = _groups as? Array
        } else {
            rooms = nil
        }
        
        if let  _friends = snapshot.value["friends"] {
             friends = _friends as? Array
        } else {
            friends = nil
        }
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["uid": uid, "name": name, "email": email]
    }
}