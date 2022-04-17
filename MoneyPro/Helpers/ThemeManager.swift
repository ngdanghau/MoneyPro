//
//  ThemeManager.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 17/04/2022.
//

import Foundation
import UIKit
import SwiftUI

class ThemeManager {
    static let shared = ThemeManager()

    private init () {}

    func handleTheme(darkMode: Bool, system: Bool) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        guard !system else {
            windowScene?.windows.first?.overrideUserInterfaceStyle = .unspecified
            return
        }
        
        windowScene?.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }

}
