//
//  GoalView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject private var viewModel: GoalViewModel
      
    @State private var editDeposit: Bool = false
    @State private var editMode: Bool = false
    @State private var showingModalView = false
        
    @State var confirmationShown: Bool = false
    @State var selectedTab: Int = 1
            
    init(state: AppState){
        viewModel = GoalViewModel(authAPI: AuthService(), state: state)
    }

    private let listTitle: [Int: String] = [
        1: "Incomplete",
        2: "Completed"
    ]
    
    var body: some View {
        List {
            Section(header: Text("Filter by date")){
                VStack{
                    DatePicker(selection: $viewModel.dateFrom, in: ...Date(), displayedComponents: .date) {
                        Text("Date From")
                    }
                    .onChange(of: viewModel.dateFrom) { newQuery in
                        viewModel.getListGoal()
                    }
                }
                
                VStack{
                    DatePicker(selection: $viewModel.dateTo, in: ...Date(), displayedComponents: .date) {
                        Text("Date To")
                    }
                    .onChange(of: viewModel.dateTo) { newQuery in
                        viewModel.getListGoal()
                    }
                }
            }
            Section(header: Text(listTitle[selectedTab] ?? "")){
                Button(action: {
                    viewModel.newGoal()
                    showingModalView = true
                }){
                    GoalRowAdd()
                }
                
                ForEach(viewModel.goals) { item in
                    Button(action: {
                        if editMode {
                            viewModel.setGoal(goal: item)
                            confirmationShown = true
                        } else if item.status == 1 {
                            editDeposit = true
                            viewModel.setGoalDeposit(goal: item)
                            showingModalView = true
                        }
                    }){
                        GoalRow(
                            goal: item,
                            editMode: $editMode
                        )
                    }
                    .foregroundColor(.black)
                    .swipeActions(allowsFullSwipe: false){
                        if editMode {
                            EmptyView()
                        }else {
                            Button(
                                role: .destructive,
                                action: {
                                    viewModel.setGoal(goal: item)
                                    confirmationShown = true
                                }
                            ){
                                Image(systemName: "trash")
                            }
                            
                            Button(
                                action: {
                                    viewModel.setGoal(goal: item)
                                    showingModalView = true
                                }
                            ){
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                }
            }
            
            if viewModel.recordsTotal != viewModel.goals.count  {
                Section{
                    Button(action: {
                        print("fetch Data goals load more")
                        viewModel.getNextListGoal()
                    }){
                        Text("Load More")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            
        }
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
        .searchable(text: $viewModel.search)
        .onSubmit(of: .search) {
            viewModel.getListGoal()
        }
        .fullScreenCover(isPresented: $showingModalView) {
            openModal()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack{
                    Picker(
                        selection: $viewModel.selectedTab,
                        label: Text("Picker"),
                        content: {
                            ForEach(1...2, id: \.self) { index in
                                Text(listTitle[index] ?? "").tag(index)
                            }
                    })
                    .onChange (of: viewModel.selectedTab, perform: { (value) in
                        viewModel.getListGoal()
                    })
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 200)
            }
        }
        .navigationBarItems(trailing: HStack{
            Button(editMode ? "Done" : "Edit"){
                editMode.toggle()
            }
        })
        .onAppear(){
            print("fetch Data goal")
            viewModel.getListGoal()
        }
        .alert(
            isPresented: $viewModel.showingAlert
        ){
            Alert(title: Text(viewModel.statusViewModel?.title ?? ""),
                  message: Text(viewModel.statusViewModel?.message ?? "")
            )
        }
        .confirmationDialog(
            "Are you sure?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            Button("Yes") {
                withAnimation {
                    viewModel.deleteGoal()
                    confirmationShown = false
                }
            }
            Button("No", role: .cancel) {
                confirmationShown = false
            }
        }
       
    }
    
    func performSearch() {

        }
    
    
    private func openModal() -> AnyView {
        if editDeposit {
            return AnyView(
                ModalGoalAddDepositView( viewModel: viewModel, editDeposit: $editDeposit)
            )
        }else{
            return AnyView(ModalGoalView( viewModel: viewModel))
        }
    }

}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(state: AppState())
    }
}


struct GoalRow: View {
    @Binding var editMode: Bool
    
    private var balance: Double = 0
    private var amount: Double = 0
    private var deposit: Double = 0
    private var percentage: Double = 0
    private var remaining: Double = 0
    private var totaldeposit: Double = 0
    private var goal: Goal
    private var isDone: Bool = false
    
    private let displayFormatter = DateFormatter()
    
    
    init(goal: Goal, editMode: Binding<Bool>){
        self.goal = goal
        _editMode = editMode
        balance = goal.balance
        amount = goal.amount
        deposit = goal.deposit
        
        totaldeposit = deposit + balance
        remaining = amount - totaldeposit;
        
        if remaining <= 0 {
            amount = totaldeposit
            isDone = true
        }
        
        percentage  = amount > 0 ? (totaldeposit/amount)*100 : 0;
        
        displayFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    
    var body: some View {
        HStack{
            if editMode {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
            ProgressView(value: totaldeposit, total: amount) {
                Text(goal.name)
                Text(displayFormatter.string(from: goal.deadline))
                    .italic()
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            } currentValueLabel: {
                if isDone {
                    Text("Done")
                }else{
                    Text("\(totaldeposit.withCommas()) of \(amount.withCommas()) (\(percentage, specifier: "%.2f")%)")
                }
            }
            .accentColor(isDone ? .green : .blue)
            Spacer()
        }
        .padding(.top, 5)
        .padding(.bottom, 5)
    }
}


struct GoalRowAdd: View {
    var body: some View {
        HStack{
            Image(systemName: "plus")
            Text("New Goal")
        }
        
    }
}
