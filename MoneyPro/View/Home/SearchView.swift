//
//  SearchView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 15/04/2022.
//

import SwiftUI

struct SearchView: View {
    private let state: AppState
    @ObservedObject private var viewModel: TransactionListViewModel
    @State private var isShowModalDetail: Bool = false
    private let formatter = DateFormatter()
    private let date: ReportDate
    
    init(state: AppState){
        self.state = state
        self.viewModel = TransactionListViewModel(authAPI: AuthService(), state: state)
        formatter.dateFormat = "ccc, LLL d"
        self.date = ReportDate(from: Date().startOfWeek(), to: Date().endOfWeek())

        viewModel.currentType = .none
    }
    
    var body: some View {
        NavigationView{
            VStack {
                ScrollView(.vertical){
                    ForEach(viewModel.transactionsGroupByDate.keys.sorted().reversed(), id: \.self){ key in
                        VStack{
                            if let transactions = viewModel.transactionsGroupByDate[key] {
                                if transactions.count > 0{
                                    let totalAmountInDate: Double = transactions.reduce(0){ result, trans in
                                        return result + trans.amount
                                    }
                                    
                                    TransactionRowHomeTitle(total: {
                                        return "\(state.appSettings?.currency ?? APIConfiguration.currency)\(totalAmountInDate.withCommas())"
                                    }, formatter: {
                                        return formatter.string(from: key)
                                    })

                                    ForEach(transactions, id: \.id){ transaction in
                                        Button(action: {
                                            viewModel.transaction = transaction
                                            isShowModalDetail = true
                                        }, label: {
                                            TransactionRowHome(transaction: transaction, currency: state.appSettings?.currency ?? APIConfiguration.currency)
                                        })
                                        .foregroundColor(.black)
                                    }
                                }
                               
                            }else{
                                TransactionRowHomeTitle(total: {
                                    return "\(state.appSettings?.currency ?? APIConfiguration.currency)0,00"
                                }, formatter: {
                                    return formatter.string(from: key)
                                })
                            }
                        }
                        .padding(.bottom, 20)
                            
                    }
                    
                    if viewModel.recordsTotal != viewModel.transactions.count  {
                        Section{
                            Button(action: {
                                print("fetch Data transaction load more")
                                viewModel.getNextReportListTransaction(date: date)
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
            }
            .padding(.horizontal)
            .navigationTitle("Search")
        }
        .searchable(text: $viewModel.search)
        .onChange(of: viewModel.search) { newQuery in
            viewModel.getReportListTransaction(date: date)
        }
        .overlay(){
            if viewModel.loading == .visible {
                ProgressView("")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .fullScreenCover(isPresented: $isShowModalDetail) {
            TransactionDetailView(viewModel: viewModel)
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(state: AppState())
    }
}
