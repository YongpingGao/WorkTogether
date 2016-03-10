//
//  UserLoginViewController.swift
//  WorkTogether
//
//  Created by amazin on 3/5/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit
import Firebase

class UserLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let segueIdentifier = "LogInSegue"
    
    let ref = Firebase(url: "https://worktogether.firebaseio.com")
    let usersRef = Firebase(url: "https://worktogether.firebaseio.com/users")
    
    var user: User!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ref.unauth()
//        usersRef.unauth()
    }
    
    override func viewDidAppear(animated: Bool) {
        usersRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                
                self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            }
        }
    }
    
    @IBAction func login(sender: UIButton) {
        
        guard let
        name = nameTextField.text,
        email = emailTextField.text,
        password = passwordTextField.text
        else {
            print("Please correctly input your email and password to login!")
            return
        }

        usersRef.authUser(email, password: password) { (error, authData) -> Void in
            if error == nil {
                self.user = User(uid: authData.uid, name: name, email: email)
                print("User \(name) has logged in!")
            } else {
                print("Error in authUser: \(error.description)")
            }
            
        }
    }

    @IBAction func signup(sender: UIButton) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "save", style: .Default) { (action) -> Void in
            if let textField = alert.textFields {
                let nameTextField = textField[0]
                let emailTextField = textField[1]
                let passwordTextField = textField[2]
                
                guard let
                    name = nameTextField.text,
                    email = emailTextField.text,
                    password = passwordTextField.text
                    else {
                        print("Please correctly enter your email and password to signup! ")
                        return
                    }
                
                self.usersRef.createUser(email, password: password, withCompletionBlock: { (error) -> Void in
                    if error != nil {
                        print("Error in CreateUser: \(error.description)")
                    } else { // log user in
                        
                        self.usersRef.authUser(email, password: password) { (error, authData) -> Void in
                            if error == nil {
                                self.user = User(uid: authData.uid, name: name, email: email)
                                self.usersRef.childByAppendingPath("\(authData.uid)").setValue(self.user.toAnyObject())
                                print("User \(name) has logged in!")
                            } else {
                                print("Error in authUser: \(error.description)")
                            }
                            
                        }

                    }
                    
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        
        alert.addTextFieldWithConfigurationHandler { (textName) -> Void in
            textName.placeholder = "Enter your name"
        }
        alert.addTextFieldWithConfigurationHandler { (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        alert.addTextFieldWithConfigurationHandler { (textPassword) -> Void in
            textPassword.placeholder = "Enter your password"
            textPassword.secureTextEntry = true
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func logout(segue: UIStoryboardSegue, sender: UIBarButtonItem) {
        ref.unauth()
    }
}






















