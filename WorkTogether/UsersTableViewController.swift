//
//  UsersTableViewController.swift
//  WorkTogether
//
//  Created by amazin on 3/5/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {

    let usersRef = Firebase(url: "https://worktogether.firebaseio.com/users")

    var users = [User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // retrieve user list from Firebase and append it to users
        usersRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                
                self.usersRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
                    for aUser in snapshot.children {
                        let user = User(snapshot: aUser as! FDataSnapshot)
                        self.users.append(user)
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChattingViewController" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let user = users[row]

                let chattingViewController = segue.destinationViewController as! ChattingViewController
                chattingViewController.toUser = user
            }
        }
        
        if segue.identifier == "DrawingViewController" {
            
        }
    }

}
