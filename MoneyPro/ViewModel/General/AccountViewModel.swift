//
//  AccountViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 31/03/2022.
//

import Foundation
import Combine
import SwiftUI

class AccountViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    
    @Published var loading: LoadingState = .invisible
    @Published var isEdit: Bool = true
    @Published var search: String = ""
    @Published var account: Account = Account.initial()
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    @Published var showingAlert: Bool = false
    
    @Published var recordsTotal: Int = 0
    
    private var start: Int = 0
    private let length: Int = 20
    
    
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    
    func newAccount() -> Void {
        isEdit = false
        account = Account.initial()
    }
    
    func setAccount(account: Account) -> Void{
        isEdit = true
        self.account = account
    }
    
    func getListAccount() {
        recordsTotal = 0
        accounts = []
        start = 0
        fetchDataAccount()
    }
    
    func getNextListAccount() {
        start += length
        fetchDataAccount()
        
    }
    
    private func fetchDataAccount(){
        loading = .visible
        authAPI.getListAccount( search: search, start: start, length: length, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveAccount (){
        loading = .visible
        authAPI.updateOrSaveAccount(account: account, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteAccount (){
        loading = .visible
        authAPI.deleteAccount(account: account, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension AccountViewModel {
    private func resultMapper(with resp: AccountResponse?) -> StatusViewModel {
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
                if start == 0 {
                    accounts = resp?.data ?? []
                }
                else {
                    accounts.append(contentsOf: resp?.data ?? [])
                }
            }
            
            if let id = resp?.account {
                account.id = id
                // nếu không thì kiểm tra có account không => là put || post || DELETE mới có cái properties này
                if let row = accounts.firstIndex(where: { $0.id == account.id }){
                   // nếu là delete thì xoá
                   if method == "DELETE" {
                       recordsTotal -= 1
                       accounts.remove(at: row)
                   }
                   // nếu là PUT là sửa
                   else {
                       accounts.replace(accounts[row], with: account)
                   }
               }else{
                   recordsTotal += 1
                   accounts.append(account)
               }
            }
            
            // cho hiện alert hay không, chỉ có GET là không, còn lại PUT, POST, DELETE là có hiện
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
