//
//  DrawingViewController.swift
//  WorkTogether
//
//  Created by amazin on 3/7/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit
import Firebase

class DrawingViewController: UIViewController, DrawViewDelegate {

    @IBOutlet weak var drawView: DrawView!
    
    var paths = [DrawingPath]()
    var room: Room!
    
    var userInteractionEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.delegate = self
        if !userInteractionEnabled {
            drawView.userInteractionEnabled = false
            navigationItem.title = "Guest Mode"
        } else {
            drawView.userInteractionEnabled = true
            navigationItem.title = "Host Mode"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseWrapper.Refs.roomsRef.childByAppendingPath(room.roomCode).childByAppendingPath("paths").observeEventType(.ChildAdded, withBlock: {(snapshot) -> Void in
            if let path = DrawingPath.parse(snapshot.value as! [String: AnyObject]) {
                self.paths.append(path)
                self.drawView.paths = self.paths
            }
        })
    }
    
    // MARK: - Delegate for DrawingView
    func didFinishDrawingPath(path: DrawingPath, drawView: DrawView) {
        let newPathRef = FirebaseWrapper.Refs.roomsRef.childByAppendingPath(room.roomCode).childByAppendingPath("paths").childByAutoId()
        newPathRef.setValue(path.serializeToDictionary()) { (error, firebase) -> Void in
            if error != nil {
                print(error)
            } else {
                print("User just draw a new path")
            }
        }
    }
    
    
    

}
