//
//  Constants.swift
//  Todo
//
//  Created by Pasin Suriyentrakorn on 8/7/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import CouchbaseLiteSwift

// Property Expression:

let ID = Meta.id
let NAME = Expression.property("name")
let PASSWORD = Expression.property("password")
let EMAIL = Expression.property("email")
let TYPE = Expression.property("type")
let MESSAGE = Expression.property("message")
let TIME = Expression.property("time")

// SelectResult:

let S_ID = SelectResult.expression(ID)
let S_COUNT = SelectResult.expression(Function.count(Expression.int(1)))
let S_NAME = SelectResult.expression(NAME)

let S_EMAIL = SelectResult.expression(EMAIL)
let S_PASSWORD = SelectResult.expression(PASSWORD)
let S_MESSAGE = SelectResult.expression(MESSAGE)
