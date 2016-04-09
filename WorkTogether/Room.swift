//
//  Room.swift
//  WorkTogether
//
//  Created by amazin on 3/9/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation

struct Room {

    let roomCode: String = {
        let id = NSUUID().UUIDString
        return id.substringFromIndex(id.endIndex.advancedBy(-4))
    }()
    
    var roomName: String!
    var hostUser: String! // User id
    var members = [String]()
    
    init(roomName: String, hostUser: String) {
        self.roomName = roomName
        self.hostUser = hostUser
        members.append(hostUser)
    }
    
    init(dictionary: [String: AnyObject]) {
        self.roomName = dictionary["roomName"] as! String
        self.hostUser = dictionary["hostUser"] as! String
        self.members = dictionary["members"] as! [String]
    }
    
    init(roomCode: String) {
      
    }

    func serializeToDictionary() -> [String: AnyObject] {
        return ["roomName": roomName, "hostUser": hostUser, "members": members]
    }
    
//    static func parse(dictionary: [String: AnyObject]) -> Room {
//        return Room(roomName: dictionary["roomName"] as! String, hostUser: dictionary["hostUser"] as! String, members: dictionary["members"] as! [String],  exists: dictionary["exists"] as! Bool)
//    }
//    
    
 
}