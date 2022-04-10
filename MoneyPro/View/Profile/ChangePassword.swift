//
//  ChangePassword.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 27/03/2022.
//

import SwiftUI

struct ChangePassword: View {
    @ObservedObject private var viewModel: AccountDetailsModel
    @State private var loading: Bool = false
    @State private var save: Bool = false
    @Environment(\.presentationMode) var presentationMode

    
    init(state: AppState){
        self.viewModel = AccountDetailsModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        LoadingView(isShowing: $loading){
            List{
                Section(header: Text("Information Security")){
                    HStack{
                        Text("Current Password")
                        SecureField(
                            "Current Password",
                            text: $viewModel.current_password
                        )
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.current_password){ text in
                            if viewModel.current_password != "" && !viewModel.current_password.isEmpty &&
                                viewModel.password != "" && !viewModel.password.isEmpty &&
                                viewModel.password_confirm != "" && !viewModel.password_confirm.isEmpty
                            {
                                self.save = true
                            }else {
                                self.save = false
                            }
                        }
                    }
                    
                    HStack{
                        Text("New Password")
                        SecureField(
                            "New Password",
                            text: $viewModel.password
                        )
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.password){ text in
                            if viewModel.current_password != "" && !viewModel.current_password.isEmpty &&
                                viewModel.password != "" && !viewModel.password.isEmpty &&
                                viewModel.password_confirm != "" && !viewModel.password_confirm.isEmpty
                            {
                                self.save = true
                            }else {
                                self.save = false
                            }
                        }
                    }
                    
                    HStack{
                        Text("Password Confirm")
                        SecureField(
                            "Password Confirm",
                            text: $viewModel.password_confirm
                        )
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.password_confirm){ text in
                            if viewModel.current_password != "" && !viewModel.current_password.isEmpty &&
                                viewModel.password != "" && !viewModel.password.isEmpty &&
                                viewModel.password_confirm != "" && !viewModel.password_confirm.isEmpty
                            {
                                self.save = true
                            }else {
                                self.save = false
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Change Password")
            .toolbar {
                Button("Save") {
                    UIApplication.shared.closeKeyboard()
                    self.loading = true
                    viewModel.changePassword()
                }
            }
            .onAppear(){
                viewModel.current_password = ""
                viewModel.password = ""
                viewModel.password_confirm = ""
            }
            .alert(item: self.$viewModel.statusViewModel) { status in
                Alert(title: Text(status.title),
                      message: Text(status.message),
                      dismissButton: .default(Text("OK"), action: {
                        self.loading = false
                        
                        if status.resultType == .success {
                            self.save = false
                            presentationMode.wrappedValue.dismiss()
                        }
                      })
                )
            }
        }
    }

}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword(state: AppState())
    }
}
