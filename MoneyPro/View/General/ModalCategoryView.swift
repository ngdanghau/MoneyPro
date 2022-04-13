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
                VStack(alignment: .leading) {
                    Text("Name")
                    CustomTextField(
                        placeHolderText: "Name",
                        text: $viewModel.category.name,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
                VStack(alignment: .leading) {
                    Text("Description")
                    CustomTextField(
                        placeHolderText: "Description",
                        text: $viewModel.category.description,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }

                VStack(alignment: .leading) {
                    ColorPicker("Color", selection: $viewModel.color)
                }
                .navigationTitle(viewModel.isEdit ? "Edit Category" : "New \(viewModel.selectedType.description.capitalized) Category" )
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
