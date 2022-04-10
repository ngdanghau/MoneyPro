//
//  GoalViewModel.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 31/03/2022.
//

import Foundation
import Combine
import SwiftUI

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    
    @Published var loading: Bool = false
    @Published var isEdit: Bool = true
    
    @Published var type: String = ""
    @Published var goal: Goal = Goal.initial(id: 0)
    
    @Published var dateFrom: Date = Date().startOfMonth()
    @Published var dateTo: Date = Date()
    @Published var search: String = ""
    
    @Published var selectedTab: Int = 1
    
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
    
    
    func newGoal() -> Void {
        isEdit = false
        goal = Goal.initial(id: 0)
    }
    
    func setGoal(goal: Goal) -> Void{
        isEdit = true
        self.goal = goal
    }
    
    func setGoalDeposit(goal: Goal) -> Void{
        isEdit = true
        self.goal = Goal.initial(id: goal.id)
    }
    
    func getListGoal() {
        recordsTotal = 0
        goals = []
        start = 0
        fetchDataGoals()
    }
    
    func getNextListGoal() {
        start += length
        fetchDataGoals()
    }
    
    private func fetchDataGoals(){
        loading = true
        authAPI.getListGoal( status: selectedTab, search: search, start: start, length: length, dateFrom: dateFrom, dateTo: dateTo, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveGoal (){
        loading = true
        authAPI.updateOrSaveGoal(goal: goal, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteGoal (){
        loading = true
        authAPI.deleteGoal(goal: goal, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func addDeposit (){
        loading = true
        authAPI.addDeposit(goal: goal, accessToken: state.getAccessToken())
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension GoalViewModel {
    private func resultMapper(with resp: GoalResponse?) -> StatusViewModel {
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
                if goals.count == 0 {
                    goals = resp?.data ?? []
                }else {
                    goals.append(contentsOf: resp?.data ?? [])
                }
            }
            
            // nếu không thì kiểm tra có goal không => là put || post || DELETE mới có cái properties này
            else if resp?.goal != nil{
                guard let goal = resp?.goal else{
                    return StatusViewModel.errorStatus
                }
                
                if let row = goals.firstIndex(where: { $0.id == goal.id }){
                    // nếu là delete thì xoá
                    if method == "DELETE" {
                        goals.remove(at: row)
                    }
                    // nếu là PUT là sửa
                    else {
                        goals.replace(goals[row], with: goal)
                    }
                }else{
                    recordsTotal += 1
                    goals.append(goal)
                }
               
                self.goal = goal
            }
            
            // cho hiện alert hay không, chỉ có GET là không, còn lại PUT, POST, DELETE là có hiện
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
}
