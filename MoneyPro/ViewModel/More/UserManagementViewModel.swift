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
    
    @Published var loading: Bool = false
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
        loading = true
        authAPI.getListUser( search: search, start: start, length: length, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveUser (){
        loading = true
        authAPI.updateOrSaveUser(user: user, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteUser (){
        loading = true
        authAPI.deleteUser(user: user, accessToken: state.getAccessToken())
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
        loading = false
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
                if users.count == 0 {
                    users = resp?.data ?? []
                }else {
                    users.append(contentsOf: resp?.data ?? [])
                }
                
            }
            
            // nếu không thì kiểm tra có user không => là put || post || DELETE mới có cái properties này
            else if resp?.user != nil{
                guard let entry = resp?.user else{
                    return StatusViewModel.errorStatus
                }
                
                if let row = users.firstIndex(where: { $0.id == entry.id }){
                    // nếu là delete thì xoá
                    if method == "DELETE" {
                        users.remove(at: row)
                    }
                    // nếu là PUT là sửa
                    else {
                        users.replace(users[row], with: entry)
                    }
                }else{
                    recordsTotal += 1
                    users.append(entry)
                }
               
                user = entry
            }
            
            // cho hiện alert hay không, chỉ có GET là không, còn lại PUT, POST, DELETE là có hiện
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
