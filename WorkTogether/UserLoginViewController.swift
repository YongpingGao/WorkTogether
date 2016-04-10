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
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        FirebaseWrapper.Refs.allUsersRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.user = User(authData: authData)
                FirebaseWrapper.Refs.allUsersRef.childByAppendingPath(authData.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    self.user = User(snapshot: snapshot)
                    self.performSegueWithIdentifier("LogInSegue", sender: nil)
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "LogInSegue" {
            if let tabBarController = segue.destinationViewController as? UITabBarController {
                if let navigationController = tabBarController.viewControllers?.last as? UINavigationController {
                    if let remoteConnectionViewController = navigationController.topViewController as? RemoteConnectionViewController {
                        remoteConnectionViewController.user = user
                    }
                   
                }
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

        FirebaseWrapper.Refs.allUsersRef.authUser(email, password: password) { (error, authData) -> Void in
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
                
                FirebaseWrapper.Refs.allUsersRef.createUser(email, password: password, withCompletionBlock: { (error) -> Void in
                    if error != nil {
                        print("Error in CreateUser: \(error.description)")
                    } else { // log user in
                        
                        FirebaseWrapper.Refs.allUsersRef.authUser(email, password: password) { (error, authData) -> Void in
                            if error == nil {
                                self.user = User(uid: authData.uid, name: name, email: email)
                                FirebaseWrapper.Refs.allUsersRef.childByAppendingPath("\(authData.uid)").setValue(self.user.toAnyObject())
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
        FirebaseWrapper.Refs.baseRef.unauth()
    }
}























