//
//  StatusViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import Foundation

class StatusViewModel: Identifiable, ObservableObject {
    var title: String
    var message: String
    var resultType: ResultType
    
    static let errorDefault: String = "Oops! Something went wrong. Please try again."
    
    static let successDefault: String = "Your request was successful."
    
    init(title: String, message: String, resultType: ResultType) {
        self.title = title
        self.message = message
        self.resultType = resultType
    }
    
    static var errorStatus: StatusViewModel {
        return StatusViewModel(title: "Error", message: errorDefault, resultType: .error)
    }
    
    static var successStatus: StatusViewModel {
        return StatusViewModel(title: "Successful", message: successDefault, resultType: .success)
    }
}
