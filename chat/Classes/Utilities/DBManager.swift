//
//  DBManager.swift
//  chat
//
//  Created by 楊德忻 on 2020/2/23.
//  Copyright © 2020 sean. All rights reserved.
//

import Foundation
import UIKit
import CouchbaseLiteSwift
import Contacts

class DBManager: NSObject {
    
    static let sharedInstance = DBManager()
    
    private let internalQueue = DispatchQueue(label: "SingletionInternalQueue", qos: .default, attributes: .concurrent)
    private var _dataCount: Int = 0
    
    var database: Database!
    var searchQuery: Query!
    
    var dataCount: Int {
        get {
            return internalQueue.sync {
                _dataCount
            }
        }
        
        set(newValue) {
            internalQueue.async(flags: .barrier) {
                self._dataCount = newValue
            }
        }
    }
    
    private override init() {
        print("init...")
        // Get database:
        Database.setLogLevel(.verbose, domain: .all);
        let database: Database
        do {
            database = try Database(name: "mydb")
        } catch {
            fatalError("Error opening database")
        }
        self.database = database
    }
    
    deinit {
        print("deinit...")
    }
    
    // Register user.
    func register(email: String, password: String, username: String, callback: (_ success: Bool, _ user: [String: String]?) -> Void) {
        // Check email password and username.
        
        if Utilities.checkEmail(email: email) && Utilities.checkPassword(password: password) && Utilities.checkUsername(username: username) {
            
            searchUser(email: email, password: password, name: username, callback: { success,user in
                if !success {
                    createUser(email: email, password: password, name: username, callback: { success,data in
                            callback(success,data)
                        })
                }
                else {
                    callback(false,user)
                }
            })
        }
        else {
            callback(false,nil)
        }
    }
    
    // Login use firebase.
    func login(email: String, password: String, callback: (_ success: Bool, _ user: [String: String]?) -> Void) {
        // Check email and password.
        
        if Utilities.checkEmail(email: email) && Utilities.checkPassword(password: password) {
            searchUser(email: email, password: password, name: nil, callback: { success,user in
                callback(success,user)
            })
        }
        else {
            callback(false,nil)
        }
    }
    
    
    func searchUser(email: String, password:String ,name:String?, callback: (_ success: Bool, _ user: [String: String]?) -> Void) {
        searchQuery = QueryBuilder.select(S_ID, S_NAME, S_EMAIL, S_PASSWORD)
            .from(DataSource.database(database))
        .where(TYPE.equalTo(Expression.string("user")).and(EMAIL.equalTo(Expression.string(email))).and(PASSWORD.equalTo(Expression.string(password))))
        
        do {
            for result in try searchQuery.execute() {
                var user:[String: String] = [:]
                user["id"] = result.string(forKey: "id")!
                user["email"] = result.string(forKey: "email")!
                user["name"] = result.string(forKey: "name")!
                callback(true,user)
                return
            }
            callback(false,nil)
            return
            
        } catch let error as NSError {
            NSLog("Error searching task list: %@", error)
            callback(false,nil)
        }
    }
    
    func createUser(email: String, password:String ,name:String, callback: (_ success: Bool, _ user: [String: String]?) -> Void) {
        let docId = NSUUID().uuidString
        let doc = MutableDocument(id: docId)
        doc.setValue("user", forKey: "type")
        doc.setValue(docId, forKey: "id")
        doc.setValue(email, forKey: "email")
        doc.setValue(password, forKey: "password")
        doc.setValue(name, forKey: "name")
        do {
            try database.saveDocument(doc)
            var user:[String: String] = [:]
            user["id"] = docId
            user["email"] = email
            user["name"] = name
            callback(true,user)
            return
        } catch let error as NSError {
            NSLog("Error searching task list: %@", error)
            callback(false,nil)
            return
        }
    }
    
    func createMessage(email: String, message:String ,name:String) -> Bool {
        let docId = NSUUID().uuidString
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let doc = MutableDocument(id: docId)
        doc.setValue("chatList", forKey: "type")
        doc.setValue(email, forKey: "email")
        doc.setValue(message, forKey: "message")
        doc.setValue(name, forKey: "name")
        doc.setValue(timeStamp, forKey: "time")
        do {
            try database.saveDocument(doc)
            return true
        } catch let error as NSError {
            NSLog("Error searching task list: %@", error)
            return false
        }
    }
    
    func searchChatList() -> [[String:String]]? {
        searchQuery = QueryBuilder.select(S_ID, S_NAME, S_EMAIL, S_MESSAGE)
            .from(DataSource.database(database))
            .where(TYPE.equalTo(Expression.string("chatList"))).orderBy(Ordering.expression(TIME))
        
        do {
            var list:[[String:String]] = []
            for result in try searchQuery.execute() {
                let data = ["id":result.string(forKey: "id"),
                            "email":result.string(forKey: "email"),
                            "name":result.string(forKey: "name"),
                            "message":result.string(forKey: "message")]
                list.append(data as! [String : String])
            }
            return list
            
        } catch let error as NSError {
            NSLog("Error searching task list: %@", error)
            return nil
        }
    }
    
    func closeDatabase() throws {
        try database.close()
    }
    
    func createDatabaseIndex() {
        // For task list query:
        let type = ValueIndexItem.expression(Expression.property("type"))
        let name = ValueIndexItem.expression(Expression.property("name"))
        let email = ValueIndexItem.expression(Expression.property("email"))
        let password = ValueIndexItem.expression(Expression.property("password"))
        let message = ValueIndexItem.expression(Expression.property("message"))
        
        do {
            let index = IndexBuilder.valueIndex(items: type, name, message, email)
            try database.createIndex(index, withName: "chatList")
        } catch let error as NSError {
        
        }
        
        // For tasks query:
        do {
            let index = IndexBuilder.valueIndex(items: type, email, password, name)
            try database.createIndex(index, withName: "user")
        } catch let error as NSError {
            
        }
    }
}
