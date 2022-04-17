//
//  MoneyProApp.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI

@main
struct MoneyProApp: App {
    @AppStorage ("colorSchemeApp") private var colorSchemeApp: SchemeSystem = .light
    @Environment(\.colorScheme) var colorSchemeEnv: ColorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView(state: AppState())
                .environment(\.colorScheme, colorSchemeApp == .system ? colorSchemeEnv : ( colorSchemeApp == .light ? .light : .dark))
        }
    }
}
