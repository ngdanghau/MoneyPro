//
//  AccountDetail.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 27/03/2022.
//

import SwiftUI

struct AccountDetails: View {
    @ObservedObject private var viewModel: AccountDetailsModel
    @Environment(\.presentationMode) var presentationMode
    
    init(state: AppState){
        self.viewModel = AccountDetailsModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.loading){
            List{
                Section(header: Text("Public Profile")){
                    HStack{
                        Text("First name")
                        TextField(
                            "First name",
                            text: $viewModel.firstname
                        )
                        .multilineTextAlignment(.trailing)
                    }
                    
                    HStack{
                        Text("Last name")
                        TextField(
                            "Last name",
                            text: $viewModel.lastname
                        )
                        .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Private details")){
                    HStack{
                        Text("Email")
                        Spacer()
                        Text(viewModel.state.authUser?.email ?? "")
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Account Details")
            .toolbar {
                Button("Save") {
                    UIApplication.shared.closeKeyboard()
                    viewModel.updateProfile()
                }
            }
            .onAppear(){
                viewModel.firstname = viewModel.state.authUser?.firstname ?? ""
                viewModel.lastname = viewModel.state.authUser?.lastname ?? ""
            }
            .alert(item: self.$viewModel.statusViewModel) { status in
                Alert(title: Text(status.title),
                      message: Text(status.message),
                      dismissButton: .default(Text("OK"), action: {
                        
                        if status.resultType == .success {
                            presentationMode.wrappedValue.dismiss()
                        }
                      })
                )
            }
        }
    }
}

struct AccountDetails_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetails(state: AppState())
    }
}
