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
    
    let drawingRef = Firebase(url: "https://worktogether.firebaseio.com/drawings")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        drawingRef.observeEventType(.ChildAdded, withBlock: {(snapshot) -> Void in
            if let path = DrawingPath.parse(snapshot.value as! [String: AnyObject]) {
                self.paths.append(path)
                self.drawView.paths = self.paths
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegate for DrawingView
    func didFinishDrawingPath(path: DrawingPath, drawView: DrawView) {
        let newPathRef = drawingRef.childByAutoId()
        newPathRef.setValue(path.serializeToDictionary()) { (error, firebase) -> Void in
            if error != nil {
                print(error)
            } else {
                print("User just draw a new path")
            }
        }
    }
    
    
    

}
