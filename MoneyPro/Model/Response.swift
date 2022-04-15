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
    let method: String
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

enum MoneyType: String, CaseIterable, Identifiable, Codable{
    case income = "1"
    case expense = "2"
    
    var id: String { self.rawValue }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let label = try? container.decode(Int.self)
        
        switch label {
            case 1: self = .income
            case 2: self = .expense
            default: self = .income
        }
   }
    
    var description: String {
        get {
            switch self {
                case .income:
                    return "Income"
                case .expense:
                    return "Expense"
            }
        }
    }
    
    var value: String {
        get {
            switch self {
                case .income:
                    return "income"
                case .expense:
                    return "expense"
            }
        }
    }
    
    mutating func toggle() ->Void {
        switch self {
        case .income:
            self = .expense
        case .expense:
            self = .income
        }
    }
}


/**
 Model Category
 */

struct Category: Codable, Identifiable, Equatable, Hashable {
    var id: Int
    var name: String
    var description: String
    var color: String
    var type: MoneyType
    
    static func initial(type: MoneyType) -> Category{
        return Category(id: 0, name: "", description: "", color: "", type: type)
    }
}

struct CategoryResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let summary: Summary?
    let data: [Category]?
    let category: Int?
}


/**
 Model Account
 */

struct Account: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var description: String
    var accountnumber: String
    var balance: Double
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case accountnumber
        case balance
   }
    
    static func initial() -> Account{
        return Account(id: 0, name: "", description: "", accountnumber: "", balance: 0)
    }
}

struct AccountResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let summary: Summary?
    let data: [Account]?
    let account: Int?
}



/**
 Model Goal
 */

struct Goal: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var amount: Double
    var deposit: Double
    var balance: Double
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
        return Goal(id: id, name: "", amount: 0, deposit: 0, balance: 0, deadline: Date(), status: 0)
    }
}

struct GoalResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let summary: Summary?
    let data: [Goal]?
    let goal: Int?
}


struct TransactionByDateResp: Codable {
    let amountcurrency: String
    let result: Int
    let msg: String?
    let totalamount: Double
}


/**
 Budget Model
 */

struct Budget: Codable, Identifiable, Equatable {
    var id: Int
    var amount: Double
    var fromdate: Date
    var todate: Date
    var description: String
    var category: Category
    
    enum CodingKeys: CodingKey {
        case id
        case amount
        case fromdate
        case todate
        case description
        case category
   }
    
    static func initial() -> Budget{
        return Budget(
            id: 0, amount: 0, fromdate: Date(), todate: Date(), description: "",
            category: Category(id: 0, name: "", description: "", color: "", type: .income)
        )
    }
}

struct BudgetResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let summary: Summary?
    let data: [Budget]?
    let budget: Int?
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
    let user: Int?
}



struct ReportDate: Codable {
    let from: Date
    let to: Date
    
    enum CodingKeys: CodingKey {
        case from
        case to
   }
}
/**
 Report
 */
struct ReportTotal: Identifiable, Codable {
    let id: Int
    let date: Date
    let name: String
    let value: Double
}

struct ReportTotalResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let income: [ReportTotal]?
    let expense: [ReportTotal]?
    let date: ReportDate?
}

/**
 Category Report
 */
struct CategoryReportTotal: Identifiable, Codable {
    let id: Int
    let name: String
    let color: String
    let amount: Double
    let total: Int
}

struct CategoryReportTotalResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let date: ReportDate?
    let data: [CategoryReportTotal]?
}

/**
 Transaction Report
 */
struct TransactionReportTotal: Codable {
    let day: Double
    let week: Double
    let month: Double
    let year: Double
    let totalbalance: Double
}

struct TransactionReportTotalResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let data: TransactionReportTotal?
}


/**
 Transaction Model
 */
struct Transaction: Identifiable, Codable, Equatable {
    var amount: Double
    var description: String
    var name: String
    var reference : String
    var transactiondate: Date
    var id: Int
    var type: MoneyType
    
    var account: Account
    var category: Category
    
    enum CodingKeys: CodingKey {
        case amount
        case description
        case name
        case reference
        case transactiondate
        case id
        case type
        case account
        case category
   }
    
    static func initial() -> Transaction{
        return Transaction(
            amount: 0, description: "", name: "", reference: "", transactiondate: Date(), id: 0, type: .income,
            account: Account.initial(),
            category: Category.initial(type: .income)
        )
    }
}

struct TransactionResponse: Codable {
    let result: Int
    let msg: String?
    let method: String
    let summary: Summary?
    let data: [Transaction]?
    let transaction: Int?
}

/**
 Transaction in Home
 */

struct TransactionHome: Codable, Identifiable {
    var id: Int
    var date: Date
    var values: [Transaction]
    var total: Double
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
        amount = try container.decode(Double.self, forKey: .amount)
        deposit = try container.decode(Double.self, forKey: .deposit)
        balance = try container.decode(Double.self, forKey: .balance)
        status = try container.decode(Int.self, forKey: .status)

        // decode date từ string
        let dateString = try container.decode(String.self, forKey: .deadline)
        
        // tạo một formatter theo đúng format của string Date
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
        balance = try container.decode(Double.self, forKey: .balance)
    }
}

extension ReportTotal {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        value = try container.decode(Double.self, forKey: .value)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.system
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
          
        if let date = formatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

extension Budget {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        amount = try container.decode(Double.self, forKey: .amount)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(Category.self, forKey: .category)
        
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

extension Transaction {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        reference = try container.decode(String.self, forKey: .reference)
        amount = try container.decode(Double.self, forKey: .amount)
        account = try container.decode(Account.self, forKey: .account)
        category = try container.decode(Category.self, forKey: .category)
        type = try container.decode(MoneyType.self, forKey: .type)
        
        let dateString = try container.decode(String.self, forKey: .transactiondate)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.system
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
          
        if let date = formatter.date(from: dateString) {
            transactiondate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .transactiondate,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
    }
  }
}

extension ReportDate {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let fromdateString = try container.decode(String.self, forKey: .from)
        if let date = formatter.date(from: fromdateString) {
            from = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .from,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
        }
        
        
        
        let todateString = try container.decode(String.self, forKey: .to)
        if let date = formatter.date(from: todateString) {
            to = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .to,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

