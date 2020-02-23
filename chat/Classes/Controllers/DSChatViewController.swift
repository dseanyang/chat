//
//  DSChatViewController.swift
//  chat
//
//  Created by 楊德忻 on 2018/1/26.
//  Copyright © 2018年 sean. All rights reserved.
//

import UIKit

class DSChatViewController: UIViewController {
    
    // MARK: lifCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    
    @IBAction func onTouchRegisterButton(_ sender: Any) {
        
        // Go to RegisterViewController on touch Register button.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = (storyboard.instantiateViewController(withIdentifier: "RegisterViewControllerCV") as? RegisterViewController)!
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @IBAction func onTouchLoginButton(_ sender: Any) {
        
        // Go to LoginViewController on touch Login button.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = (storyboard.instantiateViewController(withIdentifier: "LoginViewControllerCV") as? LogInViewController)!
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

