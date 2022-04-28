//
//  ApplicationSettingViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 27/03/2022.
//

import Foundation
import Combine

class ApplicationSettingViewModel: ObservableObject {
    @Published var site_name: String = ""
    @Published var site_slogan: String = ""
    @Published var site_description: String = ""
    @Published var site_keywords: String = ""
    @Published var logotype: String = ""
    @Published var logomark: String = ""
    @Published var language: Language = .english
    @Published var currency: String = ""
    
    @Published var loading: LoadingState = .invisible
    @Published var isPresented: Bool = false

    
    
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    func updateAppSettings() {
        loading = .visible
        authAPI.updateAppSettings(
            site_name: site_name,
            site_slogan: site_slogan,
            site_description: site_description,
            site_keywords: site_keywords,
            logotype: logotype,
            logomark: logomark,
            language: language.rawValue,
            currency: currency,
            accessToken: state.accessToken
        )
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func getDataSetting (){
        loading = .visible
        authAPI.getAppSetting(accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
}

// MARK: - Private helper function
extension ApplicationSettingViewModel {
    private func resultMapper(with resp: SiteSettingResponse?) -> StatusViewModel {
        isPresented = true
        loading = .invisible
        if resp?.result == 0 {
            return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if resp?.result == 1 {
            guard let method = resp?.method else{
                return StatusViewModel.errorStatus
            }
            
            state.appSettings = resp?.data
                                
            site_name = resp?.data?.site_name ?? ""
            site_slogan = resp?.data?.site_slogan ?? ""
            site_description = resp?.data?.site_description ?? ""
            site_keywords = resp?.data?.site_keywords ?? ""
            logotype = resp?.data?.logotype ?? ""
            logomark = resp?.data?.logomark ?? ""
            language = resp?.data?.language ?? .english
            currency = resp?.data?.currency ?? ""
            
            isPresented = method != "GET"
            
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
