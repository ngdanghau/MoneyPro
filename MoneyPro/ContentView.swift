//
//  ContentView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI
import UIKit

struct ContentView: View {
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
                                    .modifier(TextModifier(color: .black))
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
        }.onAppear{
            fetchDataUser()
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
            self.loading = false
            return
        }
        
        let accessToken = self.state.getAccessToken()
        if accessToken == nil {
            self.loading = false
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.loading = false
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    return
                } else if let data = data {
                    let resp = try? JSONDecoder().decode(AuthResponse.self, from: data)
                    if resp?.result == 0 || resp?.data == nil {
                        self.state.removeAccessToken()
                        return
                    }
                    self.pushView = true
                    self.indexView = 3
                    self.state.authUser = resp?.data
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
