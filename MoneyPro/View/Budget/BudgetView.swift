//
//  BudgetView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI

struct BudgetView: View {
    @ObservedObject private var viewModel: BudgetViewModel
    @ObservedObject private var viewModelCategory: CategoryViewModel
        
    @State private var showingModalView: Bool = false
    @State private var showGraph: Bool = false
    
    @State var confirmationShown: Bool = false
            
    init(state: AppState){
        self.viewModel = BudgetViewModel(authAPI: AuthService(), state: state)
        self.viewModelCategory = CategoryViewModel(authAPI: AuthService(), state: state)
    }

    var body: some View {
        List {
            Section(header: Text("Track Bugets")){
                Button(action: {
                    viewModel.newBudget()
                    showingModalView = true
                }){
                    BudgetRowAdd()
                }
                ForEach(viewModel.budgets) { item in
                    BudgetRow(
                        budget: item,
                        confirmationShown: $confirmationShown
                    )
                    .onTapGesture {
                        viewModel.setBudget(budget: item)
                        showGraph = true
                        showingModalView = true
                    }
                    .swipeActions{
                        Button(
                            role: .destructive,
                            action: {
                                viewModel.setBudget(budget: item)
                                confirmationShown = true
                            }
                        ){
                            Image(systemName: "trash")
                        }
                        
                        Button(
                            action: {
                                viewModel.setBudget(budget: item)
                                showingModalView = true
                            }
                        ){
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
                
                if viewModel.recordsTotal != viewModel.budgets.count  {
                    Section{
                        Button(action: {
                            print("fetch Data budget load more")
                            viewModel.getNextListBudget()
                        }){
                            Text("Load More")
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
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
        .fullScreenCover(isPresented: $showingModalView) {
            openModal()
        }
        .onAppear(){
            print("fetch Data budget on apper")
            viewModel.getListBudget()
        }
        .searchable(text: $viewModel.search)
        .onSubmit(of: .search) {
            print("fetch Data budget on search")
            viewModel.getListBudget()
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
                    viewModel.deleteBudget()
                    confirmationShown = false
                }
            }
            Button("No", role: .cancel) {
                confirmationShown = false
            }
        }
    }
    
    
    private func openModal() -> AnyView {
        if showGraph {
            return AnyView(
                ModalBudgetGraphView( viewModel: viewModel, viewModelCategory: viewModelCategory, showGraph: $showGraph)
            )
        }else{
            return AnyView(ModalBudgetView( viewModel: viewModel, viewModelCategory: viewModelCategory))
        }
    }

}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView(state: AppState())
    }
}


struct BudgetRow: View {
    let budget: Budget
    @Binding var confirmationShown: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(budget.category.name)
                Spacer()
                if budget.category.type == .income {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.green)
                }else {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.red)
                }
            }
           
            Text(budget.description)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Text(printDate(date: budget.todate))
                .font(.system(size: 12))
                .italic()
                .foregroundColor(.gray)
        }
        
    }
    
    private func printDate(date: Date) -> String{
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM yyyy"
        return displayFormatter.string(from: date)
    }
}

struct BudgetRowAdd: View {
    var body: some View {
        HStack{
            Image(systemName: "plus")
            Text("New Budget")
        }
        
    }
}
