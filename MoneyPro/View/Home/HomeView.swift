//
//  HomeView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import SwiftUI

struct HomeView: View {
    private let state: AppState
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject private var viewModel: TransactionListViewModel
    @ObservedObject private var viewModelTransactionReport: TransactionReportViewModel
    @State private var isShowModalDetail: Bool = false
    @State private var isShowModalSearch: Bool = false
    private let formatter = DateFormatter()


    init(state: AppState){
        self.state = state
        self.viewModel = TransactionListViewModel(authAPI: AuthService(), state: state)
        self.viewModelTransactionReport = TransactionReportViewModel(authAPI: AuthService(), state: state)
        formatter.dateFormat = "ccc, LLL d"
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    isShowModalSearch = true
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
                .font(.system(size: 25))
                .foregroundColor(colorScheme == .light ? .black : .white)
                
                Spacer()
                VStack{
                    Picker(
                        selection: $viewModel.currentType,
                        label: Text("Picker"),
                        content: {
                            ForEach(MoneyType.allCases) { moneyType in
                                if moneyType != .none {
                                    Text(moneyType.description).tag(moneyType)
                                }
                            }
                    })
                    .onChange (of: viewModel.currentType, perform: { (value) in
                        viewModel.getLastedListTransaction()
                        viewModelTransactionReport.getData(type: viewModel.currentType, date: .week)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 200)
                Spacer()
                
                Button(action: {
                    viewModel.transaction = Transaction.initial()
                    isShowModalDetail = true
                }, label: {
                    Image(systemName: "plus.circle.fill")
                })
                .font(.system(size: 25))
                .foregroundColor(colorScheme == .light ? .black : .white)
            }
            .padding(.horizontal)
            
            
            VStack{
                Text("\(viewModel.currentType == .income ? "Earned" : "Spent") this week")
                    .foregroundColor(.gray)
                
                HStack{
                    Text(state.appSettings?.currency ?? APIConfiguration.currency)
                        .foregroundColor(.gray)
                        .font(.system(size: 30))
                        .padding(.bottom, 20)
                        .padding(.trailing, -7)
                    
                    Text(viewModelTransactionReport.values.week.withCommas())
                        .font(.system(size: 50))
                }
                .padding(.bottom, -13)
                              
            }
            .fixedSize()
            .padding(.vertical, 50)
            .overlay(){
                if viewModelTransactionReport.loading == .visible {
                    ProgressView("")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            
            VStack{
                ScrollView(.vertical){
                    ForEach(viewModel.transactionsGroupByDate.keys.sorted().reversed(), id: \.self){ key in
                        VStack{
                            if let transactions = viewModel.transactionsGroupByDate[key] {
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
                                    .foregroundColor(colorScheme == .light ? .black : .white)
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
                                viewModel.getNextLastedListTransaction()
                            }){
                                Text("Load More")
                                    .foregroundColor(colorScheme == .light ? .black : .white)
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
            .overlay{
                if  viewModel.loading == .visible {
                    ProgressView("")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            
            
            
            
            Spacer()
        }
        .onAppear(){
            viewModel.getLastedListTransaction()
            viewModelTransactionReport.getData(type: viewModel.currentType, date: .week)
        }
        .fullScreenCover(isPresented: $isShowModalDetail) {
            TransactionDetailView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowModalSearch) {
            SearchView(state: state)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(state: AppState())
    }
}


struct TransactionRowHome: View {
    
    var transaction: Transaction
    var currency: String
    
    var body: some View {
        HStack{
            Image(systemName: transaction.type  == .income ? "plus" : "minus")
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
                .background(Color(UIColor(hexString: transaction.category.color)))
                .clipShape(
                    RoundedRectangle(cornerRadius: 5)
                )
                .padding(.bottom, 15)
            
           
            VStack{
                HStack{
                    Text(transaction.name)
                        .fontWeight(.medium)
                    
                    
                    Spacer()
                    
                    Text("\(currency)\(transaction.amount.withCommas())")
                        .foregroundColor(transaction.type == .income ? .green : .red)
                    
                }
                Divider()
            }
        }
        
    }
}


struct TransactionRowHomeTitle: View {
    var total: () -> String
    var formatter: () -> String
    var body: some View {
        HStack{
            VStack{
                HStack{
                    Text(formatter())
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                    
                    Spacer()
                    
                   Text(total())
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                }
                Divider()
            }
        }
        .padding(.leading, 25)
        
    }
}
