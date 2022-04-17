//
//  MoneyProApp.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI

@main
struct MoneyProApp: App {    
    var body: some Scene {
        WindowGroup {
            ContentView(state: AppState())
                .onAppear {
                    if let colorScheme = UserDefaults.standard.string(forKey: "colorScheme") {
                        ThemeManager.shared.handleTheme(darkMode: colorScheme != "light", system: colorScheme == "system")
                    }
                }
        }
    }
}
