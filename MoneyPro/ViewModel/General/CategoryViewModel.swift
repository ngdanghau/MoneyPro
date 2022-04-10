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
    
    @Published var loading: Bool = false
    @Published var isEdit: Bool = true
    
    @Published var type: String = ""
    @Published var category: Category = Category.initial(type: 1)
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
    
    
    func newCategory(type: Int) -> Void {
        isEdit = false
        self.type = getRawType(type: type)
        color = .red
        category = Category.initial(type: type)
    }
    
    func setCategory(category: Category) -> Void{
        isEdit = true
        self.category = category
        color = Color(UIColor(hexString: category.color))
    }
    
    func getListCategory(type: Int) {
        categories = []
        recordsTotal = 0
        start = 0
        self.type = getRawType(type: type)
        getDataCategory();
    }
    
    func getNextListCategory(type: Int) {
        start += length
        self.type = getRawType(type: type)
        getDataCategory();
    }
    
    private func getDataCategory(){
        loading = true
        authAPI.getListCategory(type: type, search: search, start: start, length: length, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveCategory (){
        loading = true
        category.color = UIColor(color).toHexString()
        authAPI.updateOrSaveCategory(type: type, category: category, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteCategory (){
        loading = true
        category.color = UIColor(color).toHexString()
        authAPI.deleteCategory(type: type, category: category, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    private func getRawType(type: Int) -> String{
        switch type {
        case 1: return "incomecategories"
        default: return "expensecategories"
        }
    }
}

// MARK: - Private helper function
extension CategoryViewModel {
    private func resultMapper(with resp: CategoryResponse?) -> StatusViewModel {
        showingAlert = true
        loading = false
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
                // kiểm tra nếu có data là array thì set vào list
                if categories.count == 0 {
                    categories = resp?.data ?? []
                }else {
                    categories.append(contentsOf: resp?.data ?? [])
                }
            }
            
            // nếu không thì kiểm tra có category không => là put || post || DELETE mới có cái properties này
            else if resp?.category != nil{
                guard let entry = resp?.category else{
                    return StatusViewModel.errorStatus
                }
                
                if let row = categories.firstIndex(where: { $0.id == entry.id }){
                    // nếu là delete thì xoá
                    if method == "DELETE" {
                        categories.remove(at: row)
                    }
                    // nếu là PUT là sửa
                    else {
                        categories.replace(categories[row], with: entry)
                    }
                }else{
                    recordsTotal += 1
                    categories.append(entry)
                }
               
                category = entry
            }
            
            // cho hiện alert hay không, chỉ có GET là không, còn lại PUT, POST, DELETE là có hiện
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}


