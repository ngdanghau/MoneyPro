//
//  BudgetViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 31/03/2022.
//

import Foundation
import Combine
import SwiftUI

class BudgetViewModel: ObservableObject {
    @Published var budgets: [Budget] = []
    
    @Published var loading: LoadingState = .invisible
    @Published var isEdit: Bool = true
    @Published var search: String = ""
    @Published var month: MonthItem = .jan
    @Published var year: YearItem = ._2022
    @Published var budget: Budget = Budget.initial()
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    @Published var showingAlert: Bool = false
    
    @Published var response: BudgetResponse?
    
    
    @Published var recordsTotal: Int = 0
    
    private var start: Int = 0
    private let length: Int = 20
    
    
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    
    func newBudget() -> Void {
        isEdit = false
        month = MonthItem(label: Date().month)
        year = YearItem(label: Date().year)
        budget = Budget.initial()
    }
    
    func setBudget(budget: Budget) -> Void{
        isEdit = true
        month = MonthItem(label: budget.todate.month)
        year = YearItem(label: budget.todate.year)
        self.budget = budget
    }
    
    func getListBudget() {
        recordsTotal = 0
        budgets = []
        start = 0
        fetchDataBudget()
    }
    
    func getNextListBudget() {
        start += length
        fetchDataBudget()
        
    }
    
    private func fetchDataBudget(){
        loading = .visible
        authAPI.getListBudget( search: search, start: start, length: length, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveBudget (){
        loading = .visible
        authAPI.updateOrSaveBudget(budget: budget, month: month, year: year, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteBudget (){
        loading = .visible
        authAPI.deleteBudget(budget: budget, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func getTransactionByDate (){
        loading = .visible
        authAPI.getTransactionByDate(budget: budget, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension BudgetViewModel {
    private func resultMapper(with resp: BudgetResponse?) -> StatusViewModel {
        showingAlert = true
        loading = .invisible
        response = resp
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
                // ki???m tra n???u c?? data l?? array th?? set v??o list
                if start == 0 {
                    budgets = resp?.data ?? []
                }else {
                    budgets.append(contentsOf: resp?.data ?? [])
                }
            }
            
            if let id = resp?.budget {
                budget.id = id
                // n???u kh??ng th?? ki???m tra c?? account kh??ng => l?? put || post || DELETE m???i c?? c??i properties n??y
                if let row = budgets.firstIndex(where: { $0.id == budget.id }){
                   // n???u l?? delete th?? xo??
                   if method == "DELETE" {
                       recordsTotal -= 1
                       budgets.remove(at: row)
                   }
                   // n???u l?? PUT l?? s???a
                   else {
                       budgets.replace(budgets[row], with: budget)
                   }
               }else{
                   recordsTotal += 1
                   budgets.append(budget)
               }
            }
            
            // cho hi???n alert hay kh??ng, ch??? c?? GET l?? kh??ng, c??n l???i PUT, POST, DELETE l?? c?? hi???n
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
