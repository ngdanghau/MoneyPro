//
//  User.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import Foundation
import UIKit
import SwiftUI

enum AccountType: String, CaseIterable, Identifiable, Codable  {
    case admin = "Admin"
    case member = "Member"
    
    var id: String { self.rawValue }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let label = try? container.decode(String.self)
        
        switch label {
            case "admin": self = .admin
            case "member": self = .member
            default: self = .member
        }
   }
}

struct User: Codable, Identifiable, Equatable {
    var id: Int
    var account_type: AccountType
    var email: String
    var firstname: String
    var lastname: String
    var is_active: Bool
    var date: Date
    
    enum CodingKeys: CodingKey {
        case id
        case account_type
        case email
        case firstname
        case lastname
        case is_active
        case date
   }
    
    static func initial() -> User{
        return User(id: 0, account_type: .member, email: "", firstname: "", lastname: "", is_active: false, date: Date())
    }
}



extension User {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        firstname = try container.decode(String.self, forKey: .firstname)
        lastname = try container.decode(String.self, forKey: .lastname)
        account_type = try container.decode(AccountType.self, forKey: .account_type)
        is_active = try container.decode(Bool.self, forKey: .is_active)

        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          
        if let dateTime = formatter.date(from: dateString) {
            date = dateTime
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                  in: container,debugDescription: "Date string does not match format expected by formatter.")
    }
  }
}
