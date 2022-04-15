//
//  ModalCategoryView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 31/03/2022.
//

import SwiftUI


struct ModalCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        NavigationView{
            Form {
                HStack{
                    Text("Name")
                    TextField(
                        "Name",
                        text: $viewModel.category.name
                    )
                    .multilineTextAlignment(.trailing)
                }
                HStack{
                    Text("Description")
                    TextEditor(
                        text: $viewModel.category.description
                    )
                    .multilineTextAlignment(.trailing)
                    
                }

                VStack(alignment: .leading) {
                    ColorPicker("Color", selection: $viewModel.color)
                }
                .navigationTitle(viewModel.isEdit ? "Edit Category" : "New \(viewModel.selectedType.description) Category" )
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    , trailing: Button("Done") {
                        UIApplication.shared.closeKeyboard();
                        viewModel.updateOrSaveCategory()
    
                    })
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
        }
        .alert(
            isPresented: $viewModel.showingAlert
        ){
            Alert(title: Text(viewModel.statusViewModel?.title ?? ""),
                  message: Text(viewModel.statusViewModel?.message ?? ""),
                  dismissButton: .default(Text("OK"), action: {
                    if viewModel.statusViewModel?.resultType == .success{
                        presentationMode.wrappedValue.dismiss()
                    }
                  })
            )
        }
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("Please wait...")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
    }
}
