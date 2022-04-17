//
//  AppState.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI
class AppState: ObservableObject{
    var authUser: User?
    var appSettings: SiteSetting?
    var emailSettings: EmailSetting?
    
    func setAccessToken(accessToken: String?) -> Void {
        UserDefaults.standard.set(accessToken ?? "", forKey: "accessToken")
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func removeAccessToken() -> Void {
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
    
    func setColorSheme(color: String) -> Void {
        UserDefaults.standard.set(color, forKey: "colorScheme")
    }
    
    func getColorSheme() -> String? {
        return UserDefaults.standard.string(forKey: "colorScheme")
    }
}

