//
//  AuthService.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import Foundation
import SwiftUI
import Combine


class AuthService: AuthAPI {
    /**
     Auth
     */
    func login(email: String, password: String) -> Future<AuthResponse?, Never> {
        return Future<AuthResponse?, Never> { promise in
            let url = APIConfiguration.url + "/login"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
            let postString = "username=\(email)&password=\(password)"
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(AuthResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func signUp(email: String, firstname: String, lastname: String, password: String, password_confirm: String) -> Future<AuthResponse?, Never> {
        return Future<AuthResponse?, Never> { promise in
            let url = APIConfiguration.url + "/signup"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
            let postString = "email=\(email)&firstname=\(firstname)&lastname=\(lastname)&password=\(password)&password-confirm=\(password_confirm)"
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(AuthResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    /**
     Profile
     */
    
    func updateProfile(firstname: String, lastname: String, accessToken: String?) -> Future<AuthResponse?, Never> {
        return Future<AuthResponse?, Never> { promise in
            let url = APIConfiguration.url + "/profile"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
            let postString = "firstname=\(firstname)&lastname=\(lastname)"
            
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(AuthResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func changePassword(current_password: String, password: String, password_confirm: String, accessToken: String?) -> Future<AuthResponse?, Never> {
        return Future<AuthResponse?, Never> { promise in
            let url = APIConfiguration.url + "/change-password"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
            let postString = "current-password=\(current_password)&password=\(password)&password-confirm=\(password_confirm)"
            
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(AuthResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    /**
     Site Settings
     */
    func updateAppSettings(site_name: String, site_slogan: String, site_description: String, site_keywords: String, logotype: String, logomark: String, language: String, currency: String, accessToken: String?) -> Future<SiteSettingResponse?, Never> {
        return Future<SiteSettingResponse?, Never> { promise in
            let url = APIConfiguration.url + "/settings/site"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
            let postString = "action=save&site_name=\(site_name)&site_slogan=\(site_slogan)&site_description=\(site_description)&site_keywords=\(site_keywords)&logotype=\(logotype)&logomark=\(logomark)&language=\(language)&currency=\(currency)"
            
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(SiteSettingResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func updateEmailSettings(host: String, port: String, encryption: String, auth: Bool, username: String, password: String, from: String, accessToken: String?) -> Future<EmailSettingResponse?, Never> {
        return Future<EmailSettingResponse?, Never> { promise in
            let url = APIConfiguration.url + "/settings/smtp"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
            let postString = "action=save&host=\(host)&port=\(port)&encryption=\(encryption)&auth=\(auth)&username=\(username)&password=\(password)&from=\(from)"
            
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(EmailSettingResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func getEmailSetting(accessToken: String?) -> Future<EmailSettingResponse?, Never> {
        return Future<EmailSettingResponse?, Never> { promise in
            let url = APIConfiguration.url + "/settings/smtp"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(EmailSettingResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func getAppSetting(accessToken: String?) -> Future<SiteSettingResponse?, Never> {
        return Future<SiteSettingResponse?, Never> { promise in
            let url = APIConfiguration.url + "/settings/site"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(SiteSettingResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    /**
     Category
     */
    func getListCategory(type: String, search: String, start: Int, length: Int, accessToken: String?) -> Future<CategoryResponse?, Never> {
        return Future<CategoryResponse?, Never> { promise in
            let url = APIConfiguration.url + "/\(type)"
            let query = "start=\(start)&length=\(length)&search=\(search)"

            print(query)
            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(CategoryResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func updateOrSaveCategory(type: String, category: Category, accessToken: String?) -> Future<CategoryResponse?, Never> {
        return Future<CategoryResponse?, Never> { promise in
            var url = APIConfiguration.url + "/\(type)"
            var method = "POST"
            if category.id > 0 {
                url += "/\(category.id)"
                method = "PUT"
            }
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var params: [String] = []
            let mirror = Mirror(reflecting: category)
            for case let (label?, value) in mirror.children {
                params.append("\(label)=\(value)")
            }
            
            let postString = params.joined(separator: "&")
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = method
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(CategoryResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func deleteCategory(type: String, category: Category, accessToken: String?) -> Future<CategoryResponse?, Never> {
        return Future<CategoryResponse?, Never> { promise in
            let url = APIConfiguration.url + "/\(type)/\(category.id)"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "DELETE"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(CategoryResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    /**
     Account
     */
    func getListAccount(search: String, start: Int, length: Int, accessToken: String?) -> Future<AccountResponse?, Never> {
        return Future<AccountResponse?, Never> { promise in
            let url = APIConfiguration.url + "/accounts"
            let query = "start=\(start)&length=\(length)&search=\(search)"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(AccountResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func updateOrSaveAccount(account: Account, accessToken: String?) -> Future<AccountResponse?, Never> {
        return Future<AccountResponse?, Never> { promise in
            var url = APIConfiguration.url + "/accounts"
            var method = "POST"
            if account.id > 0 {
                url += "/\(account.id)"
                method = "PUT"
            }
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var params: [String] = []
            let mirror = Mirror(reflecting: account)
            for case let (label?, value) in mirror.children {
                params.append("\(label)=\(value)")
            }
            
            let postString = params.joined(separator: "&")
            print(postString)

            var request = URLRequest(url: endpointUrl)
            request.httpMethod = method
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(AccountResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func deleteAccount(account: Account, accessToken: String?) -> Future<AccountResponse?, Never> {
        return Future<AccountResponse?, Never> { promise in
            let url = APIConfiguration.url + "/accounts/\(account.id)"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "DELETE"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(AccountResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    
    /**
     Goal
     */
    func getListGoal(status: Int, search: String, start: Int, length: Int, dateFrom: Date, dateTo: Date, accessToken: String?) -> Future<GoalResponse?, Never> {
        return Future<GoalResponse?, Never> { promise in
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy-MM-dd"
            
            
            let url = APIConfiguration.url + "/goals"
            let query = "start=\(start)&length=\(length)&status=\(status)&order[column]=deadline&order[dir]=desc&search=\(search)&dateFrom=\(displayFormatter.string(from: dateFrom))&dateTo=\(displayFormatter.string(from: dateTo))"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(GoalResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func updateOrSaveGoal(goal: Goal, accessToken: String?) -> Future<GoalResponse?, Never> {
        return Future<GoalResponse?, Never> { promise in
            var url = APIConfiguration.url + "/goals"
            var method = "POST"
            if goal.id > 0 {
                url += "/\(goal.id)"
                method = "PUT"
            }
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy-MM-dd"
            
            var params: [String] = []
            let mirror = Mirror(reflecting: goal)
            for case let (label?, value) in mirror.children {
                if let date = value as? Date {
                    params.append("\(label)=\(displayFormatter.string(from: date))")
                }else{
                    params.append("\(label)=\(value)")
                }
            }
            
            let postString = params.joined(separator: "&")
            print(postString)
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = method
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(GoalResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func deleteGoal(goal: Goal, accessToken: String?) -> Future<GoalResponse?, Never> {
        return Future<GoalResponse?, Never> { promise in
            let url = APIConfiguration.url + "/goals/\(goal.id)"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "DELETE"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(GoalResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func addDeposit(goal: Goal, accessToken: String?) -> Future<GoalResponse?, Never> {
        return Future<GoalResponse?, Never> { promise in
            let url = APIConfiguration.url + "/goals/\(goal.id)"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            let postString = "action=deposit&deposit=\(goal.deposit)"
            print(postString)
            print(endpointUrl)
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(GoalResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    
    /**
     Budget
     */
    func getListBudget(search: String, start: Int, length: Int, accessToken: String?) -> Future<BudgetResponse?, Never> {
        return Future<BudgetResponse?, Never> { promise in
            let url = APIConfiguration.url + "/budgets"
            let query = "start=\(start)&length=\(length)&search=\(search)&order[column]=fromdate&order[dir]=desc"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(BudgetResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func updateOrSaveBudget(budget: Budget, month: MonthItem, year: YearItem, accessToken: String?) -> Future<BudgetResponse?, Never> {
        return Future<BudgetResponse?, Never> { promise in
            var url = APIConfiguration.url + "/budgets"
            var method = "POST"
            if budget.id > 0 {
                url += "/\(budget.id)"
                method = "PUT"
            }
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var params: [String] = []
            let mirror = Mirror(reflecting: budget)
            for case let (label?, value) in mirror.children {
                if let category = value as? Category {
                    params.append("category_id=\(category.id)")
                }else{
                    params.append("\(label)=\(value)")
                }
            }
            
            params.append("month=\(month.rawValue)")
            params.append("year=\(year.rawValue)")
            
            let postString = params.joined(separator: "&")
            print(postString)

            var request = URLRequest(url: endpointUrl)
            request.httpMethod = method
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(BudgetResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func deleteBudget(budget: Budget, accessToken: String?) -> Future<BudgetResponse?, Never> {
        return Future<BudgetResponse?, Never> { promise in
            let url = APIConfiguration.url + "/budgets/\(budget.id)"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "DELETE"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(BudgetResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func getTransactionByDate(budget: Budget, accessToken: String?) -> Future<BudgetResponse?, Never> {
        return Future<BudgetResponse?, Never> { promise in
            let url = APIConfiguration.url + "/budgets/gettransactionbydate"
            let query = "category_id=\(budget.category.id)&date=\(budget.todate.year)-\(budget.todate.month)"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(BudgetResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    /**
     User
     */
    func getListUser(search: String, start: Int, length: Int, accessToken: String?) -> Future<UserResponse?, Never> {
        return Future<UserResponse?, Never> { promise in
            let url = APIConfiguration.url + "/users"
            let query = "start=\(start)&length=\(length)&search=\(search)"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(UserResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func updateOrSaveUser(user: User, accessToken: String?) -> Future<UserResponse?, Never> {
        return Future<UserResponse?, Never> { promise in
            var url = APIConfiguration.url + "/users"
            var method = "POST"
            if user.id > 0 {
                url += "/\(user.id)"
                method = "PUT"
            }
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var params: [String] = []
            let mirror = Mirror(reflecting: user)
            for case let (label?, value) in mirror.children {
                params.append("\(label)=\(value)")
            }
            
            let postString = params.joined(separator: "&")
            print(postString)

            var request = URLRequest(url: endpointUrl)
            request.httpMethod = method
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(UserResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func deleteUser(user: User, accessToken: String?) -> Future<UserResponse?, Never> {
        return Future<UserResponse?, Never> { promise in
            let url = APIConfiguration.url + "/users/\(user.id)"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "DELETE"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(UserResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    /**
     Report
     */
    
    func getDataIncomeVsExpense(type: String, date: BarChartDateType, accessToken: String?) -> Future<ReportTotalResponse?, Never>{
        return Future<ReportTotalResponse?, Never> { promise in
            let url = APIConfiguration.url + "/home/incomevsexpense"
            let query = "type=\(type)&date=\(date.rawValue)"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(ReportTotalResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func getListCategoryInTime(type: String, date: BarChartDateType, accessToken: String?) -> Future<CategoryReportTotalResponse?, Never>{
        return Future<CategoryReportTotalResponse?, Never> { promise in
            let url = APIConfiguration.url + "/home/category/\(type)"
            let query = "date=\(date.rawValue)"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(CategoryReportTotalResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    /**
     Report Transaction
     */
    func getTotalTransaction(type: String, accessToken: String?) -> Future<TransactionReportTotalResponse?, Never>{
        return Future<TransactionReportTotalResponse?, Never> { promise in
            let url = APIConfiguration.url + "/transactions/\(type)/gettotal"

            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(TransactionReportTotalResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
    /**
    Transaction
     */
    func getReportListTransaction(type: String, fromdate: Date, todate: Date, category: Int, start: Int, length: Int, accessToken: String?) -> Future<TransactionResponse?, Never>{
        return Future<TransactionResponse?, Never> { promise in
            let url = APIConfiguration.url + "/report/transactions/\(type)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let query = "order[column]=transactiondate&order[dir]=desc&fromdate=\(formatter.string(from: fromdate))&todate=\(formatter.string(from: todate))&category_id=\(category)&start=\(start)&length=\(length)"

            guard let endpointUrl = URL(string: "\(url)?\(query)") else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
            
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            print(endpointUrl)
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(TransactionResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func updateOrSaveTransaction(transaction: Transaction, accessToken: String?) -> Future<TransactionResponse?, Never> {
        return Future<TransactionResponse?, Never> { promise in
            var url = APIConfiguration.url + "/transactions"
            var method = "POST"
            if transaction.id > 0 {
                url += "/\(transaction.id)"
                method = "PUT"
            }
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                      
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy-MM-dd"
                    
            var params: [String] = []
            let mirror = Mirror(reflecting: transaction)
            for case let (label?, value) in mirror.children {
                if let category = value as? Category {
                    params.append("category_id=\(category.id)")
                }else if let account = value as? Account {
                    params.append("account_id=\(account.id)")
                }else if let date = value as? Date {
                    params.append("\(label)=\(displayFormatter.string(from: date))")
                }else {
                    params.append("\(label)=\(value)")
                }
            }
            
            let postString = params.joined(separator: "&")
            print(postString)

            var request = URLRequest(url: endpointUrl)
            request.httpMethod = method
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(TransactionResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    func deleteTransaction(transaction: Transaction, accessToken: String?) -> Future<TransactionResponse?, Never> {
        return Future<TransactionResponse?, Never> { promise in
            let url = APIConfiguration.url + "/transactions/\(transaction.id)"
            guard let endpointUrl = URL(string: url) else {
                print("endpointUrl is invalid")
                promise(.success(nil))
                return
            }
                        
            guard let token = accessToken, !token.isEmpty else {
                print("Token not found")
                promise(.success(nil))
                return
            }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "DELETE"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
                        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                        print(error?.localizedDescription ?? "error http code")
                        promise(.success(nil))
                        return
                    } else if let data = data {
                        do {
                            let resp = try JSONDecoder().decode(TransactionResponse.self, from: data)
                            print(resp)
                            promise(.success(resp))
                            return;
                        } catch DecodingError.keyNotFound(let key, let context) {
                             print("could not find key \(key) in JSON: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                             print("could not find type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                             print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        } catch DecodingError.dataCorrupted(let context) {
                             print("data found to be corrupted in JSON: \(context.debugDescription)")
                        } catch let error as NSError {
                             NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        }
                        
                        promise(.success(nil))
                        
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }else{
                        promise(.success(nil))
                    }
                }
            }.resume()
        }
    }
    
    
}
