//
//  ModalGoalView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 01/04/2022.
//

import SwiftUI

struct ModalGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GoalViewModel
    
    var body: some View {
        NavigationView{
            List {
                HStack{
                    Text("Name")
                    TextField(
                        "Name",
                        text: $viewModel.goal.name
                    )
                    .multilineTextAlignment(.trailing)
                }
                HStack{
                    Text("Amount")
                    TextField(
                        "Amount",
                        value: $viewModel.goal.amount,
                        formatter: CustomNumberField.numberFormater
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                }
                HStack{
                    Text("Balance")
                    TextField(
                        "Balance",
                        value: $viewModel.goal.balance,
                        formatter: CustomNumberField.numberFormater
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                }
                
                
                VStack {
                   DatePicker(selection: $viewModel.goal.deadline, in: ...Date(), displayedComponents: .date) {
                       Text("Deadline")
                   }
               }
                
            }
            .navigationTitle(viewModel.isEdit ? "Edit Goal" : "New Goal" )
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                , trailing: Button("Done") {
                    UIApplication.shared.closeKeyboard();
                    viewModel.updateOrSaveGoal()
                    
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
                ProgressView("")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
    }

}
