//
//  SignUpViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var password_confirm: String = ""
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    func signUp() {
        authAPI.signUp(email: email, firstname: firstname, lastname: lastname, password: password, password_confirm: password_confirm)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension SignUpViewModel {
    private func resultMapper(with authLogin: AuthResponse?) -> StatusViewModel {
        if authLogin?.result == 0 {
            return StatusViewModel.init(title: "Error", message: authLogin?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if authLogin?.accessToken != nil {
            state.setAccessToken(accessToken: authLogin?.accessToken)
            state.authUser = authLogin?.data
            return StatusViewModel.init(title: "Successful", message: authLogin?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
