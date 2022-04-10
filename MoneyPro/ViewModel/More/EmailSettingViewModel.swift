//
//  EmailSettingViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 29/03/2022.
//

import Foundation
import Combine

class EmailSettingViewModel: ObservableObject {
    @Published var host: String = ""
    @Published var port: String = ""
    @Published var encryption: Encryption = .none
    @Published var auth: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var from: String = ""
    
    @Published var loading: Bool = false
    @Published var isPresented: Bool = false


    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState

    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI

    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }

    func updateEmailSettings() {
        loading = true
        authAPI.updateEmailSettings(
            host: host,
            port: port,
            encryption: encryption.rawValue.lowercased(),
            auth: auth,
            username: username,
            password: password,
            from: from,
            accessToken: state.getAccessToken()
        )
        .receive(on: RunLoop.main)
        .map(resultMapper)
        .replaceError(with: StatusViewModel.errorStatus)
        .assign(to: \.statusViewModel, on: self)
        .store(in: &cancellableBag)
    }
    
    func getEmailSetting(){
        loading = true
        authAPI.getEmailSetting(accessToken: state.getAccessToken())
        .receive(on: RunLoop.main)
        .map(resultMapper)
        .replaceError(with: StatusViewModel.errorStatus)
        .assign(to: \.statusViewModel, on: self)
        .store(in: &cancellableBag)
    }

}

// MARK: - Private helper function
extension EmailSettingViewModel {
private func resultMapper(with resp: EmailSettingResponse?) -> StatusViewModel {
    isPresented = true
    loading = false
    if resp?.result == 0 {
        return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
    } else if resp?.result == 1 {
        state.emailSettings = resp?.data
        
        host = resp?.data?.host ?? ""
        port = resp?.data?.port ?? ""
        auth = resp?.data?.auth ?? false
        from = resp?.data?.from ?? ""
        username = resp?.data?.username ?? ""
        password = resp?.data?.password ?? ""
        encryption = resp?.data?.encryption ?? .none
        
        isPresented = resp?.method == nil
        
        return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .success)
        
        
    } else {
        return StatusViewModel.errorStatus
    }
}
}
