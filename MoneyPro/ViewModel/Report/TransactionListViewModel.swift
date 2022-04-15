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

    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    @Published var recordsTotal: Int = 0
    
    private var start: Int = 0
    private let length: Int = 20
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    func getReportListTransaction(type: MoneyType, date: ReportDate, category: CategoryReportTotal) {
        recordsTotal = 0
        transactions = []
        start = 0
        getData(type: type, date: date, category: category)
    }
    
    func getNextReportListTransaction(type: MoneyType, date: ReportDate, category: CategoryReportTotal) {
        start += length
        getData(type: type, date: date, category: category)
        
    }
    
    private func getData(type: MoneyType, date: ReportDate, category: CategoryReportTotal){
        loading = .visible
        authAPI.getReportListTransaction( type: type, fromdate: date.from, todate: date.to, category: category.id, start: start, length: length, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveTransaction(){
        loading = .visible
        authAPI.updateOrSaveTransaction(type: transaction.type, transaction: transaction, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteTransaction(){
        loading = .visible
        authAPI.deleteTransaction(transaction: transaction, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    
    func getLastedListTransaction(type: MoneyType) {
        recordsTotal = 0
        transactions = []
        start = 0
        getDataLasted(type: type)
    }
    
    func getNextLastedListTransaction(type: MoneyType) {
        start += length
        getDataLasted(type: type)
        
    }
    
    private func getDataLasted(type: MoneyType){
        loading = .visible
        authAPI.getLatestListTransaction( type: type, start: start, length: length, accessToken: state.getAccessToken())
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
            
            if resp?.data != nil{
                // kiểm tra nếu có data là array thì set vào list
                if transactions.count == 0 {
                    transactions = resp?.data ?? []
                }else {
                    transactions.append(contentsOf: resp?.data ?? [])
                }
            }
            
            if let id = resp?.transaction {
                transaction.id = id
                // nếu không thì kiểm tra có account không => là put || post || DELETE mới có cái properties này
                if let row = transactions.firstIndex(where: { $0.id == transaction.id }){
                   // nếu là delete thì xoá
                   if method == "DELETE" {
                       recordsTotal -= 1
                       transactions.remove(at: row)
                   }
                   // nếu là PUT là sửa
                   else {
                       transactions.replace(transactions[row], with: transaction)
                   }
               }else{
                   recordsTotal += 1
                   transactions.append(transaction)
               }
            }
            
            if transactions.count > 0{
                transactionsGroupByDate = Dictionary(grouping: transactions) { $0.transactiondate }
            }
            
            // cho hiện alert hay không, chỉ có GET là không, còn lại PUT, POST, DELETE là có hiện
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}

