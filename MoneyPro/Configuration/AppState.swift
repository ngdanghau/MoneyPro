//
//  AppState.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI
import SwiftKeychainWrapper

class AppState: ObservableObject{
    var authUser: User?
    var appSettings: SiteSetting?
    var emailSettings: EmailSetting?
    
    func setAccessToken(accessToken: String?) -> Void {
        KeychainWrapper.standard.set(accessToken ?? "", forKey: "accessToken")
    }
    
    func getAccessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "accessToken")
    }
    
    func removeAccessToken() -> Void {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
    }
}
