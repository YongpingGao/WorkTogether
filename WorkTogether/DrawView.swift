//
//  DrawView.swift
//  WorkTogether
//
//  Created by amazin on 3/7/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit
import Firebase
class DrawView: UIView {
    
    var delegate: DrawViewDelegate?
    
    var currentPath: DrawingPath?
    
    var currentTouch: UITouch?
    
    var paths: [DrawingPath]{
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        paths = [DrawingPath]()
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        paths = [DrawingPath]()
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        for path in paths {
            drawPathWithContext(context!, path: path)
        }
    
        if let currentPath = currentPath {
            drawPathWithContext(context!, path: currentPath)
        }
    }
    
    
    private func drawPathWithContext(context:CGContextRef, path:DrawingPath) {

        CGContextSetLineWidth(context, path.lineWidth)
        CGContextSetStrokeColorWithColor(context, path.color)
        if path.points.count > 1 {
            CGContextMoveToPoint(context, path.points[0].x, path.points[0].y)
            for point in path.points {
                CGContextAddLineToPoint(context, point.x, point.y)
            }
            CGContextStrokePath(context)
        }
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentPath == nil {
            
            if let currentTouch = touches.first {
                // TODO Color and Width
                currentPath = DrawingPath(color: UIColor.redColor().CGColor, lineWidth: 3.0)
                
                let touchPoint = currentTouch.locationInView(self)
                currentPath?.points.append(touchPoint)
                
                setNeedsDisplay()
            }
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentPath != nil {
            let touchPoint = touches.first!.locationInView(self)
            currentPath?.points.append(touchPoint)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let currentPath = currentPath {
            
            paths.append(currentPath)
            delegate?.didFinishDrawingPath(currentPath, drawView: self)
            
            setNeedsDisplay()
           
        }
        currentTouch = nil
        currentPath = nil
    }
}

protocol DrawViewDelegate {
    func didFinishDrawingPath(path: DrawingPath, drawView: DrawView)
}














