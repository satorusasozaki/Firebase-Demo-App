//
//  ViewController.swift
//  ChatApp1
//
//  Created by Satoru Sasozaki on 6/18/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    var databaseRef: FIRDatabaseReference!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        messageTextField.delegate = self
        
        // get an instance of FIRDatabaseReference class 
        // to access to database
        databaseRef = FIRDatabase.database().reference()
        
        // Add block when a text (child) is added to the database
        databaseRef.observeEventType(FIRDataEventType.ChildAdded, withBlock: { snapshot in
            if let name = snapshot.value!.objectForKey("name") as? String,
                message = snapshot.value!.objectForKey("message") as? String {
                self.textView.text = "\(self.textView.text)\n\(name) : \(message)"
            }
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == messageTextField) {
            sendMessage()
        }
        return true
    }

    @IBAction func sendTapped(sender: UIButton) {
        sendMessage()
    }

    func sendMessage() {
        let messageData = ["name": nameTextField.text!, "message": messageTextField.text!]
        databaseRef.childByAutoId().setValue(messageData)
        messageTextField.text = ""
    }
}

