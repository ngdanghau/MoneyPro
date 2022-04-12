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
                VStack(alignment: .leading) {
                    Text("Name")
                    CustomTextField(
                        placeHolderText: "Name",
                        text: $viewModel.goal.name,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
                VStack(alignment: .leading) {
                    Text("Amount")
                    CustomTextField(
                        placeHolderText: "Amount",
                        text: $viewModel.goal.amount,
                        isPasswordType: false,
                        defaultStyle: true
                    ).keyboardType(.decimalPad)
                }
                
                
                VStack(alignment: .leading) {
                    Text("Balance")
                    CustomTextField(
                        placeHolderText: "Balance",
                        text: $viewModel.goal.balance,
                        isPasswordType: false,
                        defaultStyle: true
                    )
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
                ProgressView("Please wait...")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
    }

}
