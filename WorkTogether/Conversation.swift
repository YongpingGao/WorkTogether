//
//  Conversation.swift
//  WorkTogether
//
//  Created by amazin on 3/6/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation

struct Conversation {
    let user: User!
    let content: String?
    let timeStamp: String!
    private let dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .FullStyle
        return formatter
    }()
    
    init(user: User, timeStamp: NSDate, content: String){
        self.user = user
        self.content = content
        self.timeStamp = dateFormatter.stringFromDate(timeStamp)
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["toUser": user.name, "Time": timeStamp, "content": content!]
    }
}