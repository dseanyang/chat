//
//  Utilities.swift
//  installer
//
//  Created by Sean Yang on 2017/12/29.
//  Copyright © 2017年 qlync. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Utilities: NSObject {

    // Check username.
    class func checkUsername (username:String) -> Bool {
        if username.count < 1 || username.count > 32 {
            return false
        }
        
        let mailPattern = "^[\\u4e00-\\u9fa5A-Za-z0-9._@-]+$"
        let results = Utilities.matches(for: mailPattern, in: username)
        
        if results.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    // Check password.
    class func checkPassword (password:String) -> Bool {
        if password.count < 6 || password.count > 32 {
            return false
        }
        
        let mailPattern = "^[A-Za-z0-9_-]+$"
        let results = Utilities.matches(for: mailPattern, in: password)
        
        if results.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    // Check email.
    class func checkEmail(email:String) -> Bool {
        
        let mailPattern = "^[A-Za-z0-9._-]+@[a-z0-9.-]+.[a-z]{2,4}$"
        let results = Utilities.matches(for: mailPattern, in: email)
        
        if results.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    // Match string.
    class func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
