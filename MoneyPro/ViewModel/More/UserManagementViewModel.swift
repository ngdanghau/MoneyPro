//
//  UserManagementViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 06/04/2022.
//

import Foundation
import Combine
import SwiftUI

class UserManagementViewModel: ObservableObject {
    @Published var users: [User] = []
    
    @Published var loading: LoadingState = .invisible
    @Published var isEdit: Bool = true
    @Published var search: String = ""
    @Published var user: User = User.initial()
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
    
    
    func newUser() -> Void {
        isEdit = false
        user = User.initial()
    }
    
    func setUser(user: User) -> Void{
        isEdit = true
        self.user = user
    }
    
    func getListUser() {
        recordsTotal = 0
        users = []
        start = 0
        fetchDataUser()
    }
    
    func getNextListUser() {
        start += length
        fetchDataUser()
        
    }
    
    private func fetchDataUser(){
        loading = .visible
        authAPI.getListUser( search: search, start: start, length: length, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveUser (){
        loading = .visible
        authAPI.updateOrSaveUser(user: user, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteUser (){
        loading = .visible
        authAPI.deleteUser(user: user, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension UserManagementViewModel {
    private func resultMapper(with resp: UserResponse?) -> StatusViewModel {
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
                // ki???m tra n???u c?? data l?? array th?? set v??o list
                if start == 0 {
                    users = resp?.data ?? []
                }else {
                    users.append(contentsOf: resp?.data ?? [])
                }
                recordsTotal = users.count
            }
            
            if let id = resp?.user {
                user.id = id
                // n???u kh??ng th?? ki???m tra c?? account kh??ng => l?? put || post || DELETE m???i c?? c??i properties n??y
                if let row = users.firstIndex(where: { $0.id == user.id }){
                   // n???u l?? delete th?? xo??
                   if method == "DELETE" {
                       user.is_active = false
                   }
                    users.replace(users[row], with: user)
               }else{
                   recordsTotal += 1
                   users.append(user)
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
