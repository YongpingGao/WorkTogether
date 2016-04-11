//
//  Room.swift
//  WorkTogether
//
//  Created by amazin on 3/9/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation
import Firebase
class Room {

    var roomCode: String = {
        let id = NSUUID().UUIDString
        return id.substringFromIndex(id.endIndex.advancedBy(-4))
    }()
    var roomName: String
    var hostUser: String // User id
    var members = [String]()
    
    
    var paths = [DrawingPath]()
    
    init(roomName: String, hostUser: String) {
        self.roomName = roomName
        self.hostUser = hostUser
    }
    
    init(roomCode: String, roomName: String, hostUser: String, members: [String]) {
        self.roomCode = roomCode
        self.roomName = roomName
        self.hostUser = hostUser
        self.members = members
    }
    
    func serializeToDictionary() -> [String: AnyObject] {
        return ["roomName": roomName, "hostUser": hostUser, "members": members]
    }

 
}