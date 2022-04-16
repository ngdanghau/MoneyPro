//
//  PickerAccountView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 13/04/2022.
//

import SwiftUI

struct PickerAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject var viewModel: AccountViewModel
    
    @State private var showingModalView = false
    @Binding var account: Account

    var body: some View {

        List {
            Section{
                ForEach(viewModel.accounts) { item in
                    Button(action: {
                        account = item
                        presentationMode.wrappedValue.dismiss()
                    }){
                        HStack{
                            Text(item.name)
                            Spacer()
                            if account.id == item.id {
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
        .navigationBarItems(trailing:
            Button(action: {
                viewModel.newAccount()
                showingModalView = true
            }){
                Image(systemName: "plus")
        })
        .onAppear(){
            viewModel.getListAccount()
        }
        .searchable(text: $viewModel.search)
        .onChange(of: viewModel .search) { newValue in
            print("refetch Data account")
            viewModel.getListAccount()
        }
        .alert(
            isPresented: $viewModel.showingAlert
        ){
            Alert(title: Text(viewModel.statusViewModel?.title ?? ""),
                  message: Text(viewModel.statusViewModel?.message ?? "")
            )
        }
        .fullScreenCover(isPresented: $showingModalView) {
            ModalAccountView( viewModel: viewModel)
        }
    }

}
