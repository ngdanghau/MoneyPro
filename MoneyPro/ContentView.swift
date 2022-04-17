//
//  ContentView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @AppStorage ("siteName") private var siteName: String = ""
    @AppStorage ("accountType") private var accountType: AccountType = .member
    @AppStorage ("colorSchemeApp") private var colorSchemeApp: SchemeSystem = .system
    @AppStorage ("colorSchemeSystem") private var colorSchemeSystem: SchemeSystem = .system
    
    
    @State var indexView: Int = 1
    @State var pushView: Bool = false
    @State var loading: Bool = true
    @ObservedObject var state: AppState = AppState()
    
    var body: some View {
        NavigationView{
            LoadingView(isShowing: $loading){
                VStack{
                    NavigationLink(destination: destinationView(), isActive: $pushView) {
                        EmptyView()
                    }
                    .navigationBarHidden(true)
                    
                    VStack(spacing: 40){
                        Image("logo")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .padding(.top, 120)
                        
                        Text("Welcome to Money Pro")
                            .font(.title)
                            .foregroundColor(Color(UIConfiguration.tintColor))
                            .bold()
                        
                        Text("Manage all of your finace accounts in one place")
                            .padding(.horizontal, 60)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 25){
                            Button(action: {
                                self.indexView = self.state.getAccessToken() != nil ? 3 : 1
                                self.pushView.toggle()
                            }){
                                Text("Login")
                                    .modifier(
                                        ButtonModifier(
                                            color: UIConfiguration.tintColor,
                                            textColor: .white,
                                            width: 275,
                                            height: 55
                                        )
                                    )
                            }
                            
                            Button(action: {
                                self.indexView = self.state.getAccessToken() != nil ? 3 : 2
                                self.pushView.toggle()
                                
                            }){
                                Text("Sign Up")
                                    .modifier(TextModifier(color: colorScheme == .light ? .black : .white))
                                    .frame(width: 275, height: 55)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear{
            fetchAppState()
        }
    }
    
    private func destinationView() -> AnyView {
        switch indexView{
        case 1:
            return AnyView(SignInView( state: state ))
        case 2:
            return AnyView(SignUpView( state: state ))
        default:
            return AnyView(DashboardView( state: state ))
        }
    }
    
    private func fetchDataUser() -> Void {
        let url = APIConfiguration.url + "/profile"
        guard let endpointUrl = URL(string: url) else {
            loading = false
            return
        }
        
        let accessToken = self.state.getAccessToken()
        guard let token = accessToken, !token.isEmpty else {
            print("Token not found")
            loading = false
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                loading = false
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    return
                } else if let data = data {
                    let resp = try? JSONDecoder().decode(AuthResponse.self, from: data)
                    if resp?.result == 0 || resp?.data == nil {
                        state.removeAccessToken()
                        return
                    }
                    if resp == nil {
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }
                    
                    if let user = resp?.data {
                        pushView = true
                        indexView = 3
                        state.authUser = user
                        accountType = user.account_type
                    }
                    
                }
            }
        }.resume()
    }
    
    private func fetchAppState() -> Void {
        let url = APIConfiguration.url + "/settings/site"
        guard let endpointUrl = URL(string: url) else {
            loading = false
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    loading = false
                    return
                } else if let data = data {
                    let resp = try? JSONDecoder().decode(SiteSettingResponse.self, from: data)
                    if resp?.result == 0 || resp?.data == nil {
                        loading = false
                        return
                    }
                    if resp == nil {
                        loading = false
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(returnData)
                        }
                    }
                    if let settings = resp?.data {
                        siteName = settings.site_name
                        state.appSettings = settings
                        fetchDataUser()
                    }
                    
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(indexView: 1, pushView: false, state: AppState())
    }
}
