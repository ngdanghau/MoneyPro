//
//  TransactionListViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 12/04/2022.
//

import SwiftUI
import Foundation
import Combine

class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var transactionsGroupByDate: [Date: [Transaction]] = [Date(): []]
    @Published var loading: LoadingState = .invisible
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    @Published var showingAlert: Bool = false
    @Published var transaction: Transaction = Transaction.initial()
    @Published var response: TransactionResponse?
    
    
    @Published var currentType: MoneyType = .income
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    @Published var recordsTotal: Int = 0
    
    @Published var search: String = ""
    private var start: Int = 0
    private let length: Int = 20
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    func getReportListTransaction(date: ReportDate = ReportDate.initial(), category: CategoryReportTotal = CategoryReportTotal.initial()) {
        recordsTotal = 0
        transactions = []
        start = 0
        getData(date: date, category: category)
    }
    
    func getNextReportListTransaction(date: ReportDate = ReportDate.initial(), category: CategoryReportTotal = CategoryReportTotal.initial()) {
        start += length
        getData(date: date, category: category)
        
    }
    
    private func getData(date: ReportDate, category: CategoryReportTotal){
        loading = .visible
        authAPI.getReportListTransaction( type: currentType, search: search, date: date, category: category.id, start: start, length: length, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveTransaction(){
        loading = .visible
        authAPI.updateOrSaveTransaction(type: transaction.type, transaction: transaction, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteTransaction(){
        loading = .visible
        authAPI.deleteTransaction(transaction: transaction, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    
    func getLastedListTransaction() {
        recordsTotal = 0
        transactions = []
        start = 0
        getDataLasted()
    }
    
    func getNextLastedListTransaction() {
        start += length
        getDataLasted()
        
    }
    
    private func getDataLasted(){
        loading = .visible
        authAPI.getLatestListTransaction( type: currentType, start: start, length: length, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension TransactionListViewModel {
    private func resultMapper(with resp: TransactionResponse?) -> StatusViewModel {
        showingAlert = true
        loading = .invisible
        if resp?.result == 0 {
            return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if resp?.result == 1 {
            guard let method = resp?.method else{
                return StatusViewModel.errorStatus
            }
            
            if(resp?.summary?.total_count != nil){
                recordsTotal = resp?.summary?.total_count ?? 0
            }
            
            if let data = resp?.data {
                // ki???m tra n???u c?? data l?? array th?? set v??o list
                if start == 0 {
                    transactions = data
                }else {
                    transactions.append(contentsOf: data)
                }
            }
            
            if let id = resp?.transaction {
                transaction.id = id
                if transaction.type == currentType {
                    // n???u kh??ng th?? ki???m tra c?? account kh??ng => l?? put || post || DELETE m???i c?? c??i properties n??y
                    if let row = transactions.firstIndex(where: { $0.id == transaction.id }){
                       // n???u l?? delete th?? xo??
                       if method == "DELETE" {
                           recordsTotal -= 1
                           transactions.remove(at: row)
                       }
                       // n???u l?? PUT l?? s???a
                       else {
                           transactions.replace(transactions[row], with: transaction)
                       }
                   }else{
                       recordsTotal += 1
                       transactions.append(transaction)
                   }
                }
                
            }
            
            if transactions.count > 0 {
                transactionsGroupByDate = Dictionary(grouping: transactions) { $0.transactiondate }
            }else{
                transactionsGroupByDate = [Date(): []]
            }
            
            // cho hi???n alert hay kh??ng, ch??? c?? GET l?? kh??ng, c??n l???i PUT, POST, DELETE l?? c?? hi???n
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}

