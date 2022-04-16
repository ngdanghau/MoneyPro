//
//  PickerCategoryView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 07/04/2022.
//

import SwiftUI


struct PickerCategoryView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryViewModel
    
    @State private var showingModalView = false
    @Binding var category: Category
    
    var body: some View {
        List {
            Section{
                ForEach(viewModel.categories) { item in
                    Button(action: {
                        category = item
                        presentationMode.wrappedValue.dismiss()
                    }){
                        HStack{
                            Text(item.name)
                            Spacer()
                            if category.id == item.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .foregroundColor(colorScheme == .light ? .black : .white)
                }
            }
        }
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack{
                    Picker(
                        selection: $viewModel.selectedType,
                        label: Text("Picker"),
                        content: {
                            ForEach(MoneyType.allCases) { moneyType in
                                if moneyType != .none {
                                    Text(moneyType.description).tag(moneyType)
                                }
                            }
                    })
                    .onChange (of: viewModel.selectedType, perform: { (value) in
                        viewModel.getListCategory()
                    })
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 150)
            }
        }
        .navigationBarItems(trailing:
            Button(action: {
                viewModel.newCategory()
                showingModalView = true
            }){
                Image(systemName: "plus")
        })
        .onAppear(){
            viewModel.getListCategory()
        }
        .searchable(text: $viewModel.search)
        .onChange(of: viewModel .search) { newValue in
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
        .fullScreenCover(isPresented: $showingModalView) {
            ModalCategoryView( viewModel: viewModel)
        }
    }

}



