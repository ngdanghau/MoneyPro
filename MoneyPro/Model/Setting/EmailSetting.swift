//
//  EmailSetting.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 29/03/2022.
//

import Foundation

struct EmailSetting: Codable {
    var host: String
    var port: String
    var encryption: Encryption?
    var auth: Bool
    var username: String
    var password: String
    var from: String
}

struct EmailSettingResponse: Codable {
    let result: Int
    let msg: String?
    let method: String?
    let data: EmailSetting?
}

enum Encryption: String, CaseIterable, Identifiable, Codable {
    case none = "None"
    case tls = "TLS"
    case ssl = "SSL"
    
    var id: String { self.rawValue }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let label = try? container.decode(String.self)
        
        switch label {
            case "tls": self = .tls
            case "ssl": self = .ssl
            default: self = .none
        }
   }
}
