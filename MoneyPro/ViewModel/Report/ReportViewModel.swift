//
//  ReportViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 11/04/2022.
//


import Foundation
import Combine
import SwiftUI

class ReportViewModel: ObservableObject {
    @Published var values: [ReportTotal] = []
    @Published var loading: LoadingState = .invisible
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    @Published var showingAlert: Bool = false

    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    
    func getData(type: MoneyType, date: BarChartDateType){
        loading = .visible
        authAPI.getDataIncomeVsExpense( type: type.description.lowercased(), date: date, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension ReportViewModel {
    private func resultMapper(with resp: ReportTotalResponse?) -> StatusViewModel {
        showingAlert = true
        loading = .invisible
        if resp?.result == 0 {
            return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if resp?.result == 1 {
            if let income = resp?.income{
                values = income
            }
            
            if let expense = resp?.expense{
                values = expense
            }
            
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
