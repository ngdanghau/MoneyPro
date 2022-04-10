//
//  ModalBudgetGraphView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 07/04/2022.
//
 

import SwiftUI

struct ModalBudgetGraphView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BudgetViewModel
    @ObservedObject var viewModelCategory: CategoryViewModel
    
    @Binding var showGraph: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Budget Remaining")
                    .font(.title)
                    .bold()
                Text(String(format: "\(viewModel.response?.currency ?? "$") %.2f", getValueFromText(text: viewModel.budget.amount) - getValueFromOptinal(num: viewModel.response?.totalamount)))
                    .font(.system(size: 25))
                Spacer()
                PieChartView(
                    values: [getValueFromText(text: viewModel.budget.amount), getValueFromOptinal(num: viewModel.response?.totalamount)],
                    names: ["Planned", "Actual"],
                    formatter: {value in String(format: "\(viewModel.response?.currency ?? "$") %.2f", value)},
                    widthFraction: 0.8
                )
            }
            .navigationTitle("Budget Details")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showGraph = false
                    presentationMode.wrappedValue.dismiss()
                })
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .alert(
            isPresented: $viewModel.showingAlert
        ){
            Alert(title: Text(viewModel.statusViewModel?.title ?? ""),
                  message: Text(viewModel.statusViewModel?.message ?? "")
            )
        }
        .overlay{
            if viewModel.loading {
                ProgressView("Please wait...")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
        .onAppear(){
            viewModel.getTransactionByDate()
        }
    }
    
    private func getValueFromText(text: String) ->Double{
        return Double(text) ?? 0
    }
    
    private func getValueFromOptinal(num: Double?) -> Double {
        return viewModel.response?.totalamount ?? 0
    }
}
