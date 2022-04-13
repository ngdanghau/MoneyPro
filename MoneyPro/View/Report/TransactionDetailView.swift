//
//  TransactionDetailView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 12/04/2022.
//

import SwiftUI

struct TransactionDetailView: View {
    @ObservedObject private var viewModel: TransactionListViewModel
    @ObservedObject private var viewModelCategory: CategoryViewModel
    @ObservedObject private var viewModelAccount: AccountViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var confirmationShown: Bool = false

    init(viewModel: TransactionListViewModel){
        self.viewModel = viewModel
        self.viewModelCategory = CategoryViewModel(authAPI: AuthService(), state: viewModel.state)
        self.viewModelAccount = AccountViewModel(authAPI: AuthService(), state: viewModel.state)
    }
    
    var body: some View {
        NavigationView{
            Form {
                VStack(alignment: .leading) {
                    Text("Name")
                    CustomTextField(
                        placeHolderText: "Name",
                        text: $viewModel.transaction.name,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }

                HStack {
                    NavigationLink(destination:  PickerCategoryView(viewModel: viewModelCategory, category: $viewModel.transaction.category)) {
                        Text("Category")
                        Spacer()
                        Text(viewModel.transaction.category.name)
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    NavigationLink(destination:  PickerAccountView(viewModel: viewModelAccount, account: $viewModel.transaction.account)) {
                        Text("Account")
                        Spacer()
                        Text(viewModel.transaction.account.name)
                            .foregroundColor(.gray)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Reference")
                    CustomTextField(
                        placeHolderText: "Reference",
                        text: $viewModel.transaction.reference,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }

                VStack(alignment: .leading) {
                    Text("Amount")
                    CustomTextField(
                        placeHolderText: "Amount",
                        text: $viewModel.transaction.amount,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                    .keyboardType(.decimalPad)
                }

                VStack(alignment: .leading) {
                    Text("Description")
                    CustomTextEditor(
                        text: $viewModel.transaction.description
                    )
                }

                VStack(alignment: .leading)  {
                    DatePicker(selection: $viewModel.transaction.transactiondate, in: ...Date(), displayedComponents: .date) {
                       Text("Date")
                   }
                }
                
                if viewModel.isEdit {
                    Section{
                        Button(action: {
                            confirmationShown = true
                        }){
                            Text("Delete")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                
            }
            .navigationTitle(viewModel.isEdit ? "Edit Transaction" : "New Transaction" )
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                , trailing: Button("Save") {
                    UIApplication.shared.closeKeyboard();
                    viewModel.updateOrSaveTransaction()
                    
                })
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("Please wait...")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
        .alert(
            isPresented: $viewModel.showingAlert
        ){
            Alert(title: Text(viewModel.statusViewModel?.title ?? ""),
                  message: Text(viewModel.statusViewModel?.message ?? ""),
                  dismissButton: .default(Text("OK"), action: {
                    if viewModel.statusViewModel?.resultType == .success {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                  })
            )
        }
        .confirmationDialog(
            "Are you sure?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            Button("Yes") {
                withAnimation {
                    viewModel.deleteTransaction()
                    confirmationShown = false
                }
            }
            Button("No", role: .cancel) {
                confirmationShown = false
            }
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(viewModel: TransactionListViewModel(authAPI: AuthService(), state: AppState()))
    }
}
