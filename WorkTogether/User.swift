//
//  User.swift
//  WorkTogether
//
//  Created by amazin on 3/5/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid:String!
    let email: String!
    let name: String!
    let rooms: [Room]?
    let friends: [User]?
    
    init(uid: String, name: String, email: String) {
        self.uid = uid
        self.name = name
        self.email = email
        rooms = nil
        friends = nil
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