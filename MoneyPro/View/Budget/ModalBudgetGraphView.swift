//
//  ModalBudgetGraphView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 07/04/2022.
//
 

import SwiftUI

struct ModalBudgetGraphView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
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
                Text("\(viewModel.state.appSettings?.currency ?? APIConfiguration.currency)\((viewModel.budget.amount - getValueFromOptinal(num: viewModel.response?.totalamount)).withCommas())")
                    .font(.system(size: 25))
                Spacer()
                PieChartView(
                    values: [viewModel.budget.amount, getValueFromOptinal(num: viewModel.response?.totalamount)],
                    names: ["Planned", "Actual"],
                    formatter: {value in "\(viewModel.state.appSettings?.currency ?? APIConfiguration.currency)\(value.withCommas())"},
                    backgroundColor: colorScheme == .light ? .white : .black,
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
            if viewModel.loading == .visible {
                ProgressView("")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
        .onAppear(){
            viewModel.getTransactionByDate()
        }
    }
    
    private func getValueFromOptinal(num: Double?) -> Double {
        return num ?? 0
    }
}
