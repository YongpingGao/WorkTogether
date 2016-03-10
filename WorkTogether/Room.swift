//
//  Room.swift
//  WorkTogether
//
//  Created by amazin on 3/9/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation

struct Room {
    
    var r_id: String
    var roomCode: String
    var roomName: String
    var hostUser: User
    var members: [User]

    var exists: Bool = true
    
    
    
}