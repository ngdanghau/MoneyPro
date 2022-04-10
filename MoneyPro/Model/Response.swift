//
//  Response.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 27/03/2022.
//

import Foundation
import UIKit

struct Response: Codable {
    let result: Int
    let msg: String
}



struct AuthResponse: Codable {
    let result: Int
    let msg: String?
    let accessToken: String?
    let data: User?
}

enum ResultType {
    case success
    case error
    case fetch
}

struct Summary: Codable {
    let total_count: Int
}

struct UserTiny: Codable, Identifiable, Equatable {
    let id: Int
    let fullname: String
}


/**
 Model Category
 */

struct Category: Codable, Identifiable, Equatable, Hashable {
    var id: Int
    var name: String
    var description: String
    var color: String
    var type: Int
    
    static func initial(type: Int) -> Category{
        return Category(id: 0, name: "", description: "", color: "", type: type)
    }
}

struct CategoryResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let summary: Summary?
    let data: [Category]?
    let category: Category?
}


/**
 Model Account
 */

struct Account: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var description: String
    var accountnumber: String
    var balance: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case accountnumber
        case balance
   }
    
    static func initial() -> Account{
        return Account(id: 0, name: "", description: "", accountnumber: "", balance: "0")
    }
}

struct AccountResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let currency: String?
    let summary: Summary?
    let data: [Account]?
    let account: Account?
}



/**
 Model Goal
 */

struct Goal: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var amount: String
    var deposit: String
    var balance: String
    var deadline: Date
    var status: Int
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case amount
        case deposit
        case balance
        case deadline
        case status
   }
    
    static func initial(id: Int) -> Goal{
        return Goal(id: id, name: "", amount: "", deposit: "", balance: "", deadline: Date(), status: 0)
    }
}

struct GoalResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let currency: String?
    let summary: Summary?
    let data: [Goal]?
    let goal: Goal?
}


struct TransactionByDateResp: Codable {
    let amountcurrency: String
    let currency: String
    let result: Int
    let msg: String?
    let totalamount: Double
}


/**
 Budget Model
 */

struct Budget: Codable, Identifiable, Equatable {
    var id: Int
    var amount: String
    var fromdate: Date
    var todate: Date
    var description: String
    var category: Category
    var user: UserTiny
    
    enum CodingKeys: CodingKey {
        case id
        case amount
        case fromdate
        case todate
        case description
        case category
        case user
   }
    
    static func initial() -> Budget{
        return Budget(
            id: 0, amount: "", fromdate: Date(), todate: Date(), description: "",
            category: Category(id: 0, name: "", description: "", color: "", type: 1),
            user: UserTiny(id: 0, fullname: "")
        )
    }
}

struct BudgetResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let currency: String?
    let summary: Summary?
    let data: [Budget]?
    let budget: Budget?
    let totalamount: Double?
}


/**
 User Model
 */

struct UserResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let summary: Summary?
    let data: [User]?
    let user: User?
}


/**
 Extension
 thêm các hàm init để json decode về đúng format khi lấy từ api
 */

extension Goal {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        amount = String(try container.decode(Double.self, forKey: .amount))
        deposit = String(try container.decode(Double.self, forKey: .deposit))
        balance = String(try container.decode(Double.self, forKey: .balance))
        status = try container.decode(Int.self, forKey: .status)

        let dateString = try container.decode(String.self, forKey: .deadline)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.system
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
          
        if let date = formatter.date(from: dateString) {
            deadline = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .deadline,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
    }
  }
}

extension Account {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        accountnumber = try container.decode(String.self, forKey: .accountnumber)
        balance = String(try container.decode(Int.self, forKey: .balance))
    }
}


extension Budget {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        amount = String(try container.decode(Double.self, forKey: .amount))
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(Category.self, forKey: .category)
        user = try container.decode(UserTiny.self, forKey: .user)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let fromdateString = try container.decode(String.self, forKey: .fromdate)
        if let date = formatter.date(from: fromdateString) {
            fromdate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .fromdate,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
        }
        
        
        
        let todateString = try container.decode(String.self, forKey: .todate)
        if let date = formatter.date(from: todateString) {
            todate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .todate,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
