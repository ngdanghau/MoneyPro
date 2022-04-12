//
//  CategoryReportViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 12/04/2022.
//


import Foundation
import Combine
import SwiftUI

class CategoryReportViewModel: ObservableObject {
    @Published var values: [CategoryReportTotal] = []
    @Published var loading: LoadingState = .invisible
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    @Published var showingAlert: Bool = false
    @Published var response: CategoryReportTotalResponse?

    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    
    func getData(type: String, date: BarChartDateType){
        loading = .visible
        authAPI.getListCategoryInTime( type: type, date: date, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension CategoryReportViewModel {
    private func resultMapper(with resp: CategoryReportTotalResponse?) -> StatusViewModel {
        showingAlert = true
        loading = .invisible
        if resp?.result == 0 {
            return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if resp?.result == 1 {
            response = resp
            if let data = resp?.data{
                values = data
            }
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
