//
//  chat
//
//  Created by 楊德忻 on 2018/1/26.
//  Copyright © 2018年 sean. All rights reserved.
//
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //Pre-linked with IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var messageArray: [Message] = [Message]()
    var name = ""
    var email = ""
    
    // MARK: lifCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
    }
    
    //MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.senderUsername.textColor = UIColor.black
        // TODO:If username is same. we can't check the message is my message or not. use uid.
        if cell.senderUsername.text == self.name {
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //MARK:- TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Send & Recieve from Firebase
    
    func retrieveMessages() {
        self.messageArray = [Message]()
        let snapshotValue = DBManager.sharedInstance.searchChatList()
        
        for result in snapshotValue! {
            let text = result["message"]
            let sender = result["name"]
            let message = Message()
            message.messageBody = text!
            message.sender = sender!
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    func sendMessage() {
        messageTextfield.endEditing(true)
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        if self.email != "" {
            if DBManager.sharedInstance.createMessage(email: self.email, message: self.messageTextfield.text!, name: self.name) {
                retrieveMessages()
                print("Message saved successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextfield.text = ""
            }
        }
        
    }
    
    // MARK: Action
    
    @IBAction func onTouchSendButton(_ sender: AnyObject) {
        sendMessage()
    }
    
    @IBAction func onTouchLogoutButton(_ sender: AnyObject) {
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil else {
            print("No View Controllers to pop off")
            return
        }
    }
}
