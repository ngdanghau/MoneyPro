//
//  TransactionListView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 12/04/2022.
//

import SwiftUI

struct TransactionListView: View {
    @ObservedObject private var viewModel: TransactionListViewModel

    private var category: CategoryReportTotal
    private var date: ReportDate
    private var currency: String
    let formatter = DateFormatter()
    
    init(state: AppState, category: CategoryReportTotal, date: ReportDate, currency: String){
        self.viewModel = TransactionListViewModel(authAPI: AuthService(), state: state)
        self.category = category
        self.date = date
        self.currency = currency
        
        
        formatter.dateFormat = "ccc, MMM d"
    }
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(viewModel.transactions, id: \.id){ transaction in
                    HStack{
                        Text(formatter.string(from: transaction.transactiondate))
                        Spacer()
                        Text("\(currency)\(transaction.amount)")
                    }
                    Divider()
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("\(category.name) - \(currency)\(category.amount)")
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear(){
            viewModel.getReportListTransaction(type: "income", date: date);
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(
            state: AppState(),
            category: CategoryReportTotal(id: 0, name: "1", color: "", amount: 3000, total: 0),
            date: ReportDate(from: Date(), to: Date()),
            currency: "$"
        )
    }
}
