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

    func handleTheme(color: ColorScheme) {
    
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        windowScene?.windows.first?.overrideUserInterfaceStyle = UIUserInterfaceStyle(color)
    }

}
