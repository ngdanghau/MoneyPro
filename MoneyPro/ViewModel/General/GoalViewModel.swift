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
    
    @Published var loading: LoadingState = .invisible
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
        loading = .visible
        authAPI.getListGoal( status: selectedTab, search: search, start: start, length: length, dateFrom: dateFrom, dateTo: dateTo, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func updateOrSaveGoal (){
        loading = .visible
        authAPI.updateOrSaveGoal(goal: goal, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func deleteGoal (){
        loading = .visible
        authAPI.deleteGoal(goal: goal, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func addDeposit (){
        loading = .visible
        authAPI.addDeposit(goal: goal, accessToken: state.accessToken)
            .receive(on: RunLoop.main)
            .map(resultMapperAddDeposit)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension GoalViewModel {
    private func resultMapper(with resp: GoalResponse?) -> StatusViewModel {
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
                    goals = resp?.data ?? []
                }else {
                    goals.append(contentsOf: resp?.data ?? [])
                }
            }
            
            if let id = resp?.goal {
                goal.id = id
                // n???u kh??ng th?? ki???m tra c?? account kh??ng => l?? put || post || DELETE m???i c?? c??i properties n??y
                if let row = goals.firstIndex(where: { $0.id == goal.id }){
                   // n???u l?? delete th?? xo??
                   if method == "DELETE" {
                       recordsTotal -= 1
                       goals.remove(at: row)
                   }
                   // n???u l?? PUT l?? s???a
                   else {
                       goals.replace(goals[row], with: goal)
                   }
               }else{
                   recordsTotal += 1
                   goals.append(goal)
               }
            }
            
            // cho hi???n alert hay kh??ng, ch??? c?? GET l?? kh??ng, c??n l???i PUT, POST, DELETE l?? c?? hi???n
            showingAlert = method != "GET"
            return StatusViewModel.init(title: "Successful", message: resp?.msg ?? StatusViewModel.successDefault, resultType: .success)
        } else {
            return StatusViewModel.errorStatus
        }
    }
    
    private func resultMapperAddDeposit(with resp: GoalResponse?) -> StatusViewModel {
        showingAlert = true
        loading = .invisible
        if resp?.result == 0 {
            return StatusViewModel.init(title: "Error", message: resp?.msg ?? StatusViewModel.errorDefault, resultType: .error)
        } else if resp?.result == 1 {
            guard let method = resp?.method else{
                return StatusViewModel.errorStatus
            }
            
            if let id = resp?.goal {
                goal.id = id
                if let row = goals.firstIndex(where: { $0.id == goal.id }){
                    var entry: Goal = goals[row]
                    entry.deposit += goal.deposit
                    goals.replace(goals[row], with: entry)
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
