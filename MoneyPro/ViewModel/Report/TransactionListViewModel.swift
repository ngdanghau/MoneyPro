//
//  TransactionListViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 12/04/2022.
//

import SwiftUI
import Foundation
import Combine
import SwiftUI

class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var loading: LoadingState = .invisible
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    @Published var showingAlert: Bool = false
    @Published var response: TransactionResponse?

    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    
    func getReportListTransaction(type: String, date: ReportDate){
        loading = .visible
        authAPI.getReportListTransaction( type: type, fromdate: date.from, todate: date.to, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension TransactionListViewModel {
    private func resultMapper(with resp: TransactionResponse?) -> StatusViewModel {
        showingAlert = true
        loading = .invisible
        if resp?.result == 0 {
            return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if resp?.result == 1 {
            response = resp
            if let data = resp?.data{
                transactions = data
            }
            
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
