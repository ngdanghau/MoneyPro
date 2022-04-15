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
                HStack{
                    Text("Name")
                    TextField(
                        "Name",
                        text: $viewModel.account.name
                    )
                    .multilineTextAlignment(.trailing)
                    
                }
                HStack{
                    Text("Description")
                    TextEditor(
                        text: $viewModel.account.description
                    )
                    .multilineTextAlignment(.trailing)
                    
                }
                
                
                HStack{
                    Text("Balance")
                    TextField(
                        "Balance",
                        value: $viewModel.account.balance,
                        formatter: CustomNumberField.numberFormater
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                }
                
                HStack{
                    Text("Account Number")
                    TextField(
                        "Account Number",
                        text: $viewModel.account.accountnumber
                    )
                    .multilineTextAlignment(.trailing)
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
