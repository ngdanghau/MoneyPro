//
//  PickerCategoryView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 07/04/2022.
//

import SwiftUI


struct PickerCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryViewModel
    
    @State private var showingModalView = false
    @Binding var category: Category
    private let categoryTitle: [Int: String] = [
        1: "Income",
        2: "Expense"
    ]
    
    @State var selectedTab: Int = 1
    var body: some View {

        List {
            Section{
                ForEach(viewModel.categories) { item in
                    Text(item.name)
                        .onTapGesture {
                            category = item
                            presentationMode.wrappedValue.dismiss()
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
            Button(action: {
                viewModel.newCategory(type: selectedTab)
                showingModalView = true
            }){
                Image(systemName: "plus")
        })
        .onAppear(){
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
        .fullScreenCover(isPresented: $showingModalView) {
            ModalCategoryView( viewModel: viewModel)
        }
    }

}



