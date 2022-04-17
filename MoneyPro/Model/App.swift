//
//  App.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 10/04/2022.
//

import SwiftUI

enum LoadingState {
    case visible
    case invisible
}

struct ListItem {
    let id: Int
    let name: String
    let image: String
    let color: Color
}

enum SchemeSystem: String, CaseIterable, Identifiable, Codable {
    case light
    case dark
    case system
    
    var id: String { self.rawValue }

    var description: String {
        get {
            switch self {
                case .light:
                    return "Light Mode"
                case .dark:
                    return "Dark Mode"
                case .system:
                    return "System"
            }
        }
    }
}
