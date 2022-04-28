//
//  AppState.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI
class AppState: ObservableObject{
    private static let accessTokenKey = "access_token"
    private static let colorShemeKey = "color_sheme"

    var authUser: User?
    var appSettings: SiteSetting?
    var emailSettings: EmailSetting?
    
    var accessToken: String? {
        get {
            // Read access token from UserDefaults
            return UserDefaults.standard.string(forKey: AppState.accessTokenKey)
        }
        set {
            // Save access token to UserDefaults
            UserDefaults.standard.set(newValue, forKey: AppState.accessTokenKey)
        }
    }
    
    var colorSheme: String? {
        get {
            // Read color scheme from UserDefaults
            return UserDefaults.standard.string(forKey: AppState.colorShemeKey)
        }
        set {
            // Save color scheme to UserDefaults
            UserDefaults.standard.set(newValue, forKey: AppState.colorShemeKey)
        }
    }
}

