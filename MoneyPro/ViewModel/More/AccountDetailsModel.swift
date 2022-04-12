//
//  AccountDetailsViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 27/03/2022.
//

import Foundation
import Combine

class AccountDetailsModel: ObservableObject {
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    
    @Published var current_password: String = ""
    @Published var password: String = ""
    @Published var password_confirm: String = ""
    
    
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    
    @Published var loading: Bool = false
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    func updateProfile() {
        loading = true
        authAPI.updateProfile(firstname: firstname, lastname: lastname, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func changePassword() {
        loading = true
        authAPI.changePassword(current_password: current_password, password: password, password_confirm: password_confirm, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension AccountDetailsModel {
    private func resultMapper(with resp: AuthResponse?) -> StatusViewModel {
        loading = false
        if resp?.result == 0 {
            return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if resp?.result == 1 {
            if resp?.accessToken != nil {
                state.setAccessToken(accessToken: resp?.accessToken)
            }
            state.authUser = resp?.data
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
