//
//  CategoryView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI


struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject private var viewModel: CategoryViewModel
        
    @State private var editMode: Bool = false
    @State private var showingModalView = false
    
    @State var confirmationShown: Bool = false
    @State var selectedTab: MoneyType = .income
    
    init(state: AppState){
        viewModel = CategoryViewModel(authAPI: AuthService(), state: state)
    }

    var body: some View {
        List {
            Section(header: Text(selectedTab.description)){
                ForEach(viewModel.categories) { item in
                    Button(action: {
                        viewModel.setCategory(category: item)
                        if editMode {
                            confirmationShown = true
                        } else {
                            showingModalView = true
                        }
                    }){
                        CategoryRow(category: item, editMode: $editMode)
                    }
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .swipeActions{
                        if editMode {
                            EmptyView()
                        }else {
                            Button(
                                role: .destructive,
                                action: {
                                    viewModel.setCategory(category: item)
                                    confirmationShown = true
                                }
                            ){
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                
                if !editMode {
                    Button(action: {
                        viewModel.newCategory()
                        showingModalView = true
                    }){
                        CategoryRowAdd()
                    }
                }
                
                
                if viewModel.recordsTotal != viewModel.categories.count  {
                    Section{
                        Button(action: {
                            print("fetch Data category load more")
                            viewModel.getNextListCategory()
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
            ModalCategoryView( viewModel: viewModel)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack{
                    Picker(
                        selection: $selectedTab,
                        label: Text("Picker"),
                        content: {
                            ForEach(MoneyType.allCases) { moneyType in
                                if moneyType != .none {
                                    Text(moneyType.description).tag(moneyType)
                                }
                            }
                    })
                    .onChange (of: selectedTab, perform: { (value) in
                        viewModel.selectedType = selectedTab
                        viewModel.getListCategory()
                    })
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 150)
            }
        }
        .navigationBarItems(trailing:
                Button(editMode ? "Done" : "Edit"){
                    editMode.toggle()
        })
        .onAppear{
            print("refetch Data category")
            viewModel.getListCategory()
        }
        .searchable(text: $viewModel.search)
        .onSubmit(of: .search) {
            print("refetch Data category")
            viewModel.getListCategory()
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
                    viewModel.deleteCategory()
                    confirmationShown = false
                }
            }
            Button("No", role: .cancel) {
                confirmationShown = false
            }
        }
       
    }

}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(state: AppState())
    }
}


struct CategoryRow: View {
    let category: Category
    @Binding var editMode: Bool
    var body: some View {
        HStack{
            if editMode {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
            Text(category.name)
            Spacer()
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color(UIColor(hexString: category.color)))
                .frame(width: 25, height: 25)
        }
        
    }
}


struct CategoryRowAdd: View {
    var body: some View {
        HStack{
            Image(systemName: "plus")
            Text("New Category")
        }
        
    }
}


