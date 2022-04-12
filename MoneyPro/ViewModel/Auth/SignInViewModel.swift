//
//  SignInViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var email: String = "00xshen00@gmail.com"
    @Published var password: String = "aIRLIkMax6yBC2"
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    func login() {
        authAPI.login(email: email, password: password)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension SignInViewModel {
    private func resultMapper(with authLogin: AuthResponse?) -> StatusViewModel {
        if authLogin?.result == 0 {
            return StatusViewModel.init(title: "Error", message: authLogin?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if authLogin?.accessToken != nil {
            state.setAccessToken(accessToken: authLogin?.accessToken ?? "")
            state.authUser = authLogin?.data
            return StatusViewModel.init(title: "Successful", message: authLogin?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
