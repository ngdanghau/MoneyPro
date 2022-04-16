//
//  SignInView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State var pushView: Bool = false
    @State var loading: Bool = false
    @ObservedObject private var viewModel: SignInViewModel
    
    init(state: AppState) {
        self.viewModel = SignInViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        LoadingView(isShowing: $loading) {
            VStack{
                NavigationLink(destination: DashboardView(state: viewModel.state),
                               isActive: self.$pushView) {
                  EmptyView()
                }.hidden()
                VStack(alignment: .leading, spacing: 30){
                    Text("Login")
                        .modifier(TextModifier(color: UIConfiguration.tintColor))
                        .font(.title)
                        .padding(.leading, 25)
                        .padding(.bottom, 80)
                    
                    VStack(alignment: .center, spacing: 30){
                        VStack(alignment: .center, spacing: 25) {
                            CustomTextField(
                                placeHolderText: "E-mail",
                                text: $viewModel.email,
                                isPasswordType: false
                            )
                            
                            CustomTextField(
                                placeHolderText: "Password",
                                text: $viewModel.password,
                                isPasswordType: true
                            )
                            
                        }.padding(.horizontal, 25)
                        
                        customButton(
                            title: "Log In",
                            backgroundColor: UIConfiguration.tintColor,
                            action: {
                                viewModel.login()
                                self.loading = true
                            }
                        )
                    }
                }
                Spacer()
            }.alert(item: self.$viewModel.statusViewModel) { status in
                Alert(title: Text(status.title),
                      message: Text(status.message),
                      dismissButton: .default(Text("OK"), action: {
                        self.loading = false
                        if status.resultType == .success {
                            self.pushView = true
                        }
                      })
                )
            }
        }
        
    }
    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(color: backgroundColor,
                                         textColor: colorScheme == .light ? .black : .white,
                                         width: 275,
                                         height: 55))
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(state: AppState())
    }
}
