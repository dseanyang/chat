//
//  chatTests.swift
//  chatTests
//
//  Created by 楊德忻 on 2018/1/26.
//  Copyright © 2018年 sean. All rights reserved.
//

import XCTest
@testable import chat

class chatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCheckPassword() {
        XCTAssertTrue(Utilities.checkPassword(password:"abtZsq"))
        XCTAssertTrue(Utilities.checkPassword(password:"123456abcdefghijklmnopqrstuvwxyz"))
        XCTAssertFalse(Utilities.checkPassword(password:"0123456abcdefghijklmnopqrstuvwxyz"))
        XCTAssertFalse(Utilities.checkPassword(password:"123"))
        XCTAssertFalse(Utilities.checkPassword(password:"!~#+"))
    }
    
    func testCheckUsername() {
        XCTAssertTrue(Utilities.checkUsername(username: "一"))
        XCTAssertTrue(Utilities.checkUsername(username: "123456abcdefghijklmnopqrstuvwxyz"))
        XCTAssertFalse(Utilities.checkUsername(username: "0123456abcdefghijklmnopqrstuvwxyz"))
        XCTAssertFalse(Utilities.checkUsername(username: ""))
        XCTAssertFalse(Utilities.checkUsername(username: "!~#+"))
    }
    
    func testCheckEmail() {
        XCTAssertTrue(Utilities.checkEmail(email:"a1@gmail.com"))
        XCTAssertTrue(Utilities.checkEmail(email:"A1@gmail.com"))
        XCTAssertFalse(Utilities.checkEmail(email: "a1@gmail.A"))
        XCTAssertFalse(Utilities.checkEmail(email: "a1gmail.com"))
        XCTAssertFalse(Utilities.checkEmail(email: ""))
    }
    
    func testLogin() {
        let expect = expectation(description: "Should login success")
        
        DBManager.sharedInstance.login (email: "a1@gmail.com", password: "123456", callback:{success, user in
            if success {
                expect.fulfill()
            } else {
                XCTFail("Invalid username or password")
            }
        })
        
        waitForExpectations(timeout: 2.0) { (err) in
            if err != nil {
                XCTFail("timeout")
            }
        }
    }
    
    func testRegister() {
        let expect = expectation(description: "Should register fail")
        
        DBManager.sharedInstance.register (email: "a1@gmail.com", password: "123456", username: "a1", callback:{success,user in
            if success {
                XCTFail("register suceess")
            }
            else {
                XCTAssertFalse(success)
                expect.fulfill()
            }
        })
        
        waitForExpectations(timeout: 2.0) { (err) in
            if err != nil {
                XCTFail("timeout")
            }
        }
    }
}
