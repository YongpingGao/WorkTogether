//
//  Utility.swift
//  WorkTogether
//
//  Created by amazin on 3/9/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation


class RoomCodeGenerator {
    
    private let letterBase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    private let CODE_LENGTH = 4
    var delegate: RoomCodeGeneratorDelegate?
    var randomCodeString: String {
        get {
            var tempString = ""
            let length = letterBase.characters.count
            for _ in 0..<CODE_LENGTH {
                tempString = tempString + String(letterBase[arc4random_uniform(UInt32(length))])
            }
            if let _delegate = delegate {
                while(!_delegate.didFinishGenerateRoomCode(tempString)){};
            }
            return tempString
        }
    }
    
}


protocol RoomCodeGeneratorDelegate {
    func didFinishGenerateRoomCode(roomCode: String) -> Bool
}


private extension String {
    subscript (i: UInt32) -> Character {
        return self[self.startIndex.advancedBy(Int(i))]
    }
}


 