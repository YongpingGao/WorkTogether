//
//  DrawingPath.swift
//  WorkTogether
//
//  Created by amazin on 3/7/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import Foundation
import UIKit

class DrawingPath {
    
    var color: CGColor!
    var lineWidth: CGFloat!
    var points: [CGPoint]!
    
    init(color: CGColor, lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
        points = [CGPoint]()
    }
    
    func serializeToDictionary() -> [String: AnyObject] {
        var dictionary = [String: AnyObject]()
        dictionary["color"] = 256 // TODO
        dictionary["lineWidth"] = Float(lineWidth)
        
        let pointsDictionary = [String: Float]()
        var pointsArray = [pointsDictionary]
        for point in points {
            pointsArray.append(["x" : Float(point.x), "y": Float(point.y)])
        }
        
        dictionary["points"] = pointsArray
        
        return dictionary
 
    }
    
    class func parse(dictionary: [String: AnyObject]) -> DrawingPath? {
        
        guard let
            lineWidth = dictionary["lineWidth"] as? Float,
            points = dictionary["points"] as? [AnyObject]
            else {
            print("dictionary of drawing path is empty")
            return nil
        }
        var _points = [CGPoint]()
        for obj in points {
            if let _obj = obj as? [String: NSNumber] {
                let point = CGPoint(x: CGFloat(_obj["x"]!), y: CGFloat(_obj["y"]!))
                _points.append(point)
            }
        }

        let path = DrawingPath(color: UIColor.redColor().CGColor, lineWidth: CGFloat(lineWidth))
        path.points = _points
        return path
        
    }
    
    
  
    
}
 