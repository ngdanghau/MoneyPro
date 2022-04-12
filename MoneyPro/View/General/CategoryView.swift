//
//  CategoryView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI


struct CategoryView: View {
    @ObservedObject private var viewModel: CategoryViewModel
        
    @State private var editMode: Bool = false
    @State private var showingModalView = false
    
    @State var confirmationShown: Bool = false
    @State var selectedTab: Int = 1
    
    private let categoryTitle: [Int: String] = [
        1: "Income",
        2: "Expense"
    ]
    
    
    
    init(state: AppState){
        viewModel = CategoryViewModel(authAPI: AuthService(), state: state)
    }

    var body: some View {
        List {
            Section(header: Text(categoryTitle[selectedTab] ?? "")){
                ForEach(viewModel.categories) { item in
                    CategoryRow(
                        category: item,
                        editMode: $editMode,
                        confirmationShown: $confirmationShown
                    )
                    .onTapGesture {
                        viewModel.setCategory(category: item)
                        if editMode {
                            confirmationShown = true
                        } else {
                            showingModalView = true
                        }
                    }
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
                        viewModel.newCategory(type: selectedTab)
                        showingModalView = true
                    }){
                        CategoryRowAdd()
                    }
                }
                
                
                if viewModel.recordsTotal != viewModel.categories.count  {
                    Section{
                        Button(action: {
                            print("fetch Data category load more")
                            viewModel.getNextListCategory(type: selectedTab)
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
                ProgressView("Please wait...")
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
                            ForEach(1...2, id: \.self) { index in
                                Text(categoryTitle[index] ?? "").tag(index)
                            }
                    })
                    .onChange (of: selectedTab, perform: { (value) in
                        viewModel.getListCategory(type: value)
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
            viewModel.getListCategory(type: selectedTab)
        }
        .searchable(text: $viewModel.search)
        .onSubmit(of: .search) {
            print("refetch Data category")
            viewModel.getListCategory(type: selectedTab)
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
    @Binding var confirmationShown: Bool
    var body: some View {
        HStack{
            if editMode {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
            Text(category.name)
            Spacer()
            Rectangle()
                .foregroundColor(Color(UIColor(hexString: category.color)))
                .frame(width: 25, height: 25)
                .cornerRadius(7)
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


