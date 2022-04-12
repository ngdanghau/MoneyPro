//
//  ModalBudgetView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 07/04/2022.
//

import SwiftUI

struct ModalBudgetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BudgetViewModel
    @ObservedObject var viewModelCategory: CategoryViewModel
    
    private let categoryTitle: [Int: String] = [
        1: "Income",
        2: "Expense"
    ]
    
    @State var selectedTab: Int = 1
    var body: some View {
        NavigationView{
            Form {
                HStack{
                    Picker("Month", selection: $viewModel.month) {
                        List {
                            ForEach(MonthItem.allCases) { month in
                                Text(month.description).tag(month)
                            }
                        }
                    }.disabled(viewModel.isEdit)
                }
                
                HStack {
                    Picker("Year", selection: $viewModel.year) {
                        List {
                            ForEach(YearItem.allCases) { year in
                                Text(year.id).tag(year)
                            }
                        }
                    }.disabled(viewModel.isEdit)
                }
                
                HStack {
                    NavigationLink(destination:  PickerCategoryView(viewModel: viewModelCategory, category: $viewModel.budget.category)) {
                        Text("Category")
                        Spacer()
                        Text(viewModel.budget.category.name)
                    }
                    .disabled(viewModel.isEdit)

               }
                
                
                VStack(alignment: .leading) {
                    Text("Amount")
                    CustomTextField(
                        placeHolderText: "Amount",
                        text: $viewModel.budget.amount,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                    .keyboardType(.decimalPad)
                }
                VStack(alignment: .leading) {
                    Text("Description")
                    CustomTextEditor(
                        text: $viewModel.budget.description
                    )
                }
                
            }
            .navigationTitle(viewModel.isEdit ? "Edit Budget" : "New Budget" )
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                , trailing: Button("Done") {
                    UIApplication.shared.closeKeyboard();
                    viewModel.updateOrSaveBudget()
                    
                })
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("Please wait...")
                  .progressViewStyle(CircularProgressViewStyle())
              }
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
    }

}




enum MonthItem: String, CaseIterable, Identifiable, Codable {
    case jan = "01"
    case feb = "02"
    case mar = "03"
    case apr = "04"
    case may = "05"
    case jun = "06"
    case jul = "07"
    case aug = "08"
    case sep = "09"
    case oct = "10"
    case nov = "11"
    case dec = "12"
    
    var id: String { self.rawValue }
    
    init(label: String) {
        switch label {
            case "01": self = .jan
            case "02": self = .feb
            case "03": self = .mar
            case "04": self = .apr
            case "05": self = .may
            case "06": self = .jun
            case "07": self = .jul
            case "08": self = .aug
            case "09": self = .sep
            case "10": self = .oct
            case "11": self = .nov
            case "12": self = .dec
            default: self = .jan
        }
   }
    
    var description: String {
        get {
            switch self {
            case .jan: return "Jan"
            case .feb: return "Feb"
            case .mar: return "Mar"
            case .apr: return "Apr"
            case .may: return "May"
            case .jun: return "Jun"
            case .jul: return "Jul"
            case .aug: return "Aug"
            case .sep: return "Sep"
            case .oct: return "Oct"
            case .nov: return "Nov"
            case .dec: return "Dec"
            }
        }
    }
}

enum YearItem: String, CaseIterable, Identifiable, Codable {
    case _2022 = "2022"
    case _2023 = "2023"
    case _2024 = "2024"
    case _2025 = "2025"
    case _2026 = "2026"
    case _2027 = "2027"
    case _2028 = "2028"
    case _2029 = "2029"
    case _2030 = "2030"
    case _2031 = "2031"
    case _2032 = "2032"
    
    var id: String { self.rawValue }
    
    init(label: String) {
        switch label {
            case "2022": self = ._2022
            case "2023": self = ._2023
            case "2024": self = ._2024
            case "2025": self = ._2025
            case "2026": self = ._2026
            case "2027": self = ._2027
            case "2028": self = ._2028
            case "2029": self = ._2029
            case "2030": self = ._2030
            case "2031": self = ._2031
            case "2032": self = ._2032
            default: self = ._2022
        }
   }
}


