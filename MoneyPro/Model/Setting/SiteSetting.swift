//
//  SiteSetting.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 28/03/2022.
//

import SwiftUI

struct SiteSetting: Codable {
    let site_name: String
    let site_description: String
    let site_keywords: String
    let currency: String
    let logomark: String
    let logotype: String
    let site_slogan: String
    let language: Language?
    
    static func initial() -> SiteSetting{
        return SiteSetting(site_name: "", site_description: "", site_keywords: "", currency: "", logomark: "", logotype: "", site_slogan: "", language: .english)
    }
}


struct SiteSettingResponse: Codable {
    let result: Int
    let msg: String?
    let method: String?
    let data: SiteSetting?
}

enum Language: String, CaseIterable, Identifiable, Codable {
    case english = "en-US"
    case vietnamese = "vi-VN"
    
    var id: String { self.rawValue }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let label = try? container.decode(String.self)
        
        switch label {
            case "vi-VN": self = .vietnamese
            case "en-US": self = .english
            default: self = .english
        }
   }
    
    var description: String {
        get {
            switch self {
                case .english:
                    return "English"
                case .vietnamese:
                    return "Vietnamese"
            }
        }
    }
}
