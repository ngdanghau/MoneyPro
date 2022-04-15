//
//  ModalGoalAddDepositView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 02/04/2022.
//

import SwiftUI

struct ModalGoalAddDepositView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GoalViewModel
    
    @Binding var editDeposit: Bool
    
    var body: some View {
        NavigationView{
            Form {
                HStack{
                    Text("Deposit")
                    TextField(
                        "Deposit",
                        value: $viewModel.goal.deposit,
                        formatter: CustomNumberField.numberFormater
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Deposit")
            .navigationBarItems(
                leading: Button("Cancel") {
                    editDeposit = false
                    presentationMode.wrappedValue.dismiss()
                }
                , trailing: Button("Done") {
                    UIApplication.shared.closeKeyboard();
                    viewModel.addDeposit()
                    
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
                        editDeposit = false
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
