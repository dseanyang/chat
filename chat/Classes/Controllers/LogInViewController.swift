//
//  chat
//
//  Created by 楊德忻 on 2018/1/26.
//  Copyright © 2018年 sean. All rights reserved.
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD
import CouchbaseLiteSwift
import Contacts

class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    //UILabel pre-linked with IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    
    var errorMessage:String! = ""
    var database: Database!
    var searchQuery: Query!
    // MARK: lifCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get database:
        let app = UIApplication.shared.delegate as! AppDelegate
        database = app.database
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Action
    
    // Dissmiss keyboad on touch began.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
    }
    
    // Focus on password on touch return button.
    @IBAction func emailDidEndOnExit(_ sender: UITextField) {
        self.passwordTextfield.becomeFirstResponder()
    }
    
    // Dissmiss keyboad on touch finish button.
    @IBAction func passwordDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onTouchLoginButton(_ sender: AnyObject) {
        SVProgressHUD.show()
        self.messageLabel.text = ""
        dissmissKeyboad()
        login(email: emailTextfield.text!, password: passwordTextfield.text!)
    }
    
    // MARK: function
    
    func dissmissKeyboad() {
        self.emailTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
    }
    
    func login(email:String, password:String) {
        DBManager.sharedInstance.login (email: email, password: password, callback:{success, user in
            if success {
                // Login success.
                print("Login successful")
                self.errorMessage = ""
                // Login and go to chat View.
                AppDelegate.goToChatView(controller:self,email: email, name:user?["name"])
            }
            else {
                // Login fail
                self.errorMessage = "Invalid email or password"
            }
            self.messageLabel.text = self.errorMessage
            SVProgressHUD.dismiss()
        })
    }
}  
