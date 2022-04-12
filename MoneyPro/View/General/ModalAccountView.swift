//
//  ModalAccountView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 01/04/2022.
//

import SwiftUI

struct ModalAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        NavigationView{
            Form {
                VStack(alignment: .leading) {
                    Text("Name")
                    CustomTextField(
                        placeHolderText: "Name",
                        text: $viewModel.account.name,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
                VStack(alignment: .leading) {
                    Text("Description")
                    CustomTextField(
                        placeHolderText: "Description",
                        text: $viewModel.account.description,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
                
                
                VStack(alignment: .leading) {
                    Text("Balance")
                    CustomTextField(
                        placeHolderText: "Balance",
                        text: $viewModel.account.balance,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                    .keyboardType(.decimalPad)
                }
                
                VStack(alignment: .leading) {
                    Text("Account Number")
                    CustomTextField(
                        placeHolderText: "Account Number",
                        text: $viewModel.account.accountnumber,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }

                
            }
            .navigationTitle(viewModel.isEdit ? "Edit Account" : "New Account" )
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                , trailing: Button("Done") {
                    UIApplication.shared.closeKeyboard();
                    viewModel.updateOrSaveAccount()
                    
                })
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
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
