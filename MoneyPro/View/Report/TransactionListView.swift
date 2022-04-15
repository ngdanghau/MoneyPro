//
//  TransactionListView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 12/04/2022.
//

import SwiftUI

struct TransactionListView: View {
    @ObservedObject private var viewModel: TransactionListViewModel

    @State private var showingModalView: Bool = false
    private var category: CategoryReportTotal
    private var date: ReportDate
    private var currency: String
    private var typeCurrent: MoneyType = .income
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
                    Button(action: {
                        showingModalView = true
                        viewModel.transaction = transaction
                    }){
                        HStack{
                            Text(formatter.string(from: transaction.transactiondate))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(currency)\(transaction.amount.withCommas())")
                        }
                    }
                    .foregroundColor(.black)
                    Divider()
                }
                if viewModel.recordsTotal != viewModel.transactions.count  {
                    Section{
                        Button(action: {
                            print("fetch Data transaction load more")
                            viewModel.getNextReportListTransaction(type: typeCurrent, date: date, category: category)
                        }){
                            Text("Load More")
                                .foregroundColor(.black)
                                .padding(8)
                                .background(
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.gray, lineWidth: 1)
                                    }
                                )
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("\(category.name) - \(currency)\(category.amount.withCommas())")
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear(){
            viewModel.getReportListTransaction(type: typeCurrent, date: date, category: category);
        }
        .fullScreenCover(isPresented: $showingModalView) {
            TransactionDetailView(viewModel: viewModel)
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(
            state: AppState(),
            category: CategoryReportTotal(id: 0, name: "1", color: "", amount: 3000, total: 0),
            date: ReportDate(from: Date(), to: Date()),
            currency: APIConfiguration.currency
        )
    }
}
