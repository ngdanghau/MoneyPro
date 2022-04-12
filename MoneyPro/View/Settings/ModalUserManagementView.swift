//
//  ModalUserManagementView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 06/04/2022.
//

import SwiftUI

struct ModalUserManagementView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: UserManagementViewModel
    
    var body: some View {
        NavigationView{
            List {
                
                Section(header: Text("Public Profile")){
                    VStack(alignment: .leading) {
                        Text("First Name")
                        CustomTextField(
                            placeHolderText: "First Name",
                            text: $viewModel.user.firstname,
                            isPasswordType: false,
                            defaultStyle: true
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Last Name")
                        CustomTextField(
                            placeHolderText: "Last Name",
                            text: $viewModel.user.lastname,
                            isPasswordType: false,
                            defaultStyle: true
                        )
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
                        VStack(alignment: .leading) {
                            Text("Email")
                            CustomTextField(
                                placeHolderText: "Email",
                                text: $viewModel.user.email,
                                isPasswordType: false,
                                defaultStyle: true
                            )
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
                ProgressView("Please wait...")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
    }
    
}
