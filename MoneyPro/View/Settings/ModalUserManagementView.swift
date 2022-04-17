//
//  ModalUserManagementView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 06/04/2022.
//

import SwiftUI

struct ModalUserManagementView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: UserManagementViewModel
    
    var body: some View {
        NavigationView{
            List {
                
                Section(header: Text("Public Profile")){
                    HStack{
                        Text("First Name")
                        TextField(
                            "First name",
                            text: $viewModel.user.firstname
                        )
                        .multilineTextAlignment(.trailing)
                    }
                    
                    HStack{
                        Text("Last Name")
                        TextField(
                            "Last name",
                            text: $viewModel.user.lastname
                        )
                        .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Role")){
                    VStack(alignment: .leading) {
                        Picker("Account Type", selection: $viewModel.user.account_type) {
                              ForEach(AccountType.allCases) { role in
                                  Text(role.rawValue).tag(role)
                              }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Toggle("Active", isOn: $viewModel.user.is_active)
                    }
                }
                
                Section(header: Text("Private details")){
                    if viewModel.isEdit {
                        HStack{
                            Text("Email")
                            Spacer()
                            Text(viewModel.user.email)
                        }
                    }else{
                        HStack{
                            Text("Email")
                            TextField(
                                "Email",
                                text: $viewModel.user.email
                            )
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.none)
                            
                        }
                    }
                }

                
            }
            .navigationTitle(viewModel.isEdit ? "Edit User" : "New User" )
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                , trailing: Button("Done") {
                    UIApplication.shared.closeKeyboard();
                    viewModel.updateOrSaveUser()
                    
                })
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(
            isPresented: $viewModel.showingAlert
        ){
            Alert(title: Text(viewModel.statusViewModel?.title ?? ""),
                  message: Text(viewModel.statusViewModel?.message ?? ""),
                  dismissButton: .default(Text("OK"), action: {
                    if viewModel.statusViewModel?.resultType == .success {
                        presentationMode.wrappedValue.dismiss()
                    }
                  })
            )
        }
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
    }
    
}
