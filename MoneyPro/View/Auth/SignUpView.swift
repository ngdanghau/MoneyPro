//
//  SignUpView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject private var viewModel: SignUpViewModel
    
    init(state: AppState) {
        self.viewModel = SignUpViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.loading) {
            VStack{
                NavigationLink(destination: DashboardView(state: viewModel.state),
                               isActive: $viewModel.pushView) {
                  EmptyView()
                }.hidden()
                VStack(alignment: .leading, spacing: 30) {
                    Text("Create a new account")
                        .modifier(TextModifier(color: UIConfiguration.tintColor))
                        .padding(.leading, 25)
                        .font(.title)
                    VStack(alignment: .center, spacing: 30) {
                        VStack(alignment: .center, spacing: 25) {
                            CustomTextField(
                                placeHolderText: "Fisrt Name",
                                text: $viewModel.firstname,
                                isPasswordType: false
                            )
                            
                            CustomTextField(
                                placeHolderText: "Last Name",
                                text: $viewModel.lastname,
                                isPasswordType: false
                            )
                            
                            CustomTextField(
                                placeHolderText: "E-mail Address",
                                text: $viewModel.email,
                                isPasswordType: false
                            )
                            .autocapitalization(.none)
                            
                            CustomTextField(
                                placeHolderText: "Password",
                                text: $viewModel.password,
                                isPasswordType: true
                            )
                            .autocapitalization(.none)
                            
                            CustomTextField(
                                placeHolderText: "Password Confirm",
                                text: $viewModel.password_confirm,
                                isPasswordType: true
                            )
                            .autocapitalization(.none)
                            
                        }.padding(.horizontal, 25)
                        
                        VStack(alignment: .center, spacing: 40) {
                            customButton(
                                title: "Create Account",
                                backgroundColor: UIColor(hexString: "#334D92"),
                                action: {
                                    viewModel.signUp()
                                }
                            )
                        }
                    }
                }
                Spacer()
            }.alert(item: $viewModel.statusViewModel) { status in
                Alert(title: Text(status.title),
                      message: Text(status.message),
                      dismissButton: .default(Text("OK"), action: {
                        if status.resultType == .success {
                            viewModel.pushView = true
                        }
                      }))
            }
        }
    }
    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(color: backgroundColor,
                                         textColor: colorScheme == .light ? .white : .black,
                                         width: 275,
                                         height: 45))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(state: AppState())
    }
}
