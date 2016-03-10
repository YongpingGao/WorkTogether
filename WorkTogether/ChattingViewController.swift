//
//  ChattingViewController.swift
//  WorkTogether
//
//  Created by amazin on 3/7/16.
//  Copyright © 2016 yongpinggao. All rights reserved.
//

import UIKit
import Firebase

class ChattingViewController: UIViewController {

    @IBOutlet weak var chatTextField: UITextField!
    
    @IBOutlet weak var conversationLabel: UILabel!
    
    let conversationRef = Firebase(url: "https://worktogether.firebaseio.com/conversation")
    
    
    var toUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTextField.placeholder = "To: \(toUser.name)"
    }
    
    override func viewDidAppear(animated: Bool) {
        conversationRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            for item in snapshot.children {

                if let dictionary = item as? FDataSnapshot {
                     self.conversationLabel.text = dictionary.value["content"] as? String
                }
               
                
            }
            
        })
    }

    @IBAction func send(sender: UIButton) {
        
        if let message = chatTextField.text {
//            refConversation.setValue(message)
            let conversation = Conversation(user: toUser, timeStamp: NSDate(), content: message)
            let newConversationRef = conversationRef.childByAutoId()
            newConversationRef.setValue(conversation.toAnyObject())
//            conversationRef.setValue(["a":"a", "b":"b"])
        }
        
    }
}
