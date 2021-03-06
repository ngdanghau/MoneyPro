//
//  CategoryViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 31/03/2022.
//

import Foundation
import Combine
import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    @Published var loading: LoadingState = .invisible
    @Published var isEdit: Bool = true
    
    @Published var selectedType: MoneyType = .income
    @Published var category: Category = Category.initial(type: .income)
    @Published var color: Color = .red
    @Published var search: String = ""
    
    @Published var statusViewModel: StatusViewModel?
    @Published var state: AppState
    
    @Published var showingAlert: Bool = false
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    @Published var recordsTotal: Int = 0
    
    private var start: Int = 0
    private let length: Int = 20
    
    init(authAPI: AuthAPI, state: AppState) {
        self.authAPI = authAPI
        self.state = state
    }
    
    
    func newCategory() -> Void {
        isEdit = false
        color = .red
        category = Category.initial(type: selectedType)
    }
    
    func setCategory(category: Category) -> Void{
        isEdit = true
        self.category = category
        color = Color(UIColor(hexString: category.color))
    }
    
    func getListCategory() {
        categories = []
        recordsTotal = 0
        start = 0
        getDataCategory();
    }
    
    func getNextListCategory() {
        start += length
        getDataCategory();
    }
    
    private func getDataCategory(){
        loading = .visible
        authAPI.getListCategory(type: getRawType(), search: search, start: start, length: length, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveCategory (){
        loading = .visible
        category.color = UIColor(color).toHexString()
        authAPI.updateOrSaveCategory(type: getRawType(), category: category, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteCategory (){
        loading = .visible
        category.color = UIColor(color).toHexString()
        authAPI.deleteCategory(type: getRawType(), category: category, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    private func getRawType() -> String{
        switch selectedType {
        case .income: return "incomecategories"
        case .expense: return "expensecategories"
        case .none: return "none"
        }
    }
}

// MARK: - Private helper function
extension CategoryViewModel {
    private func resultMapper(with resp: CategoryResponse?) -> StatusViewModel {
        showingAlert = true
        loading = .invisible
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
                // ki???m tra n???u c?? data l?? array th?? set v??o list
                if start == 0 {
                    categories = resp?.data ?? []
                }else {
                    categories.append(contentsOf: resp?.data ?? [])
                }
            }
            
            if let id = resp?.category {
                category.id = id
                // n???u kh??ng th?? ki???m tra c?? account kh??ng => l?? put || post || DELETE m???i c?? c??i properties n??y
                if let row = categories.firstIndex(where: { $0.id == category.id }){
                   // n???u l?? delete th?? xo??
                   if method == "DELETE" {
                       recordsTotal -= 1
                       categories.remove(at: row)
                   }
                   // n???u l?? PUT l?? s???a
                   else {
                       categories.replace(categories[row], with: category)
                   }
               }else{
                   recordsTotal += 1
                   categories.append(category)
               }
            }
            
            // cho hi???n alert hay kh??ng, ch??? c?? GET l?? kh??ng, c??n l???i PUT, POST, DELETE l?? c?? hi???n
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}


