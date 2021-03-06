//
//  RoomMembersViewController.swift
//  WorkTogether
//
//  Created by amazin on 3/10/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit

class RoomMembersViewController: UITableViewController {
    
    var room: Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.room.members.removeAll()
        FirebaseWrapper.Refs.roomsRef.childByAppendingPath(room.roomCode).childByAppendingPath("members").observeEventType(.ChildAdded, withBlock: { snapshot in
            let memberAdded = snapshot.value as! String
            if !self.room.members.contains(memberAdded) {
                self.room.members.append(memberAdded)
                self.tableView.reloadData()
            }
        })
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.room.members.removeAll()
        super.viewDidDisappear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.members.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RoomMembersCell", forIndexPath: indexPath)

        cell.textLabel?.text = room.members[indexPath.row]

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ItemButtonSegue" {
            if let drawingViewController = segue.destinationViewController as? DrawingViewController {
                drawingViewController.room = room // else triggered automatically
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
