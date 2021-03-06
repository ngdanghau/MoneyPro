//
//  AccountView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject private var viewModel: AccountViewModel
        
    @State private var editMode: Bool = false
    @State private var showingModalView = false
    
    @State var confirmationShown: Bool = false
            
    init(state: AppState){
        viewModel = AccountViewModel(authAPI: AuthService(), state: state)
    }

    var body: some View {
        List {
            ForEach(viewModel.accounts) { item in
                Button(action: {
                    viewModel.setAccount(account: item)
                    if editMode {
                        confirmationShown = true
                    } else {
                        showingModalView = true
                    }
                }){
                    AccountRow(account: item, editMode: $editMode)
                }
                .foregroundColor(colorScheme == .light ? .black : .white)
                .swipeActions{
                    if editMode {
                        EmptyView()
                    }else {
                        Button(
                            role: .destructive,
                            action: {
                                viewModel.setAccount(account: item)
                                confirmationShown = true
                            }
                        ){
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            
            if viewModel.recordsTotal != viewModel.accounts.count  {
                Section{
                    Button(action: {
                        print("fetch Data account load more")
                        viewModel.getNextListAccount()
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
        .fullScreenCover(isPresented: $showingModalView) {
            ModalAccountView( viewModel: viewModel)
        }
        .navigationBarTitle("Accounts", displayMode: .inline)
        .navigationBarItems(trailing: HStack{
            Button(editMode ? "Done" : "Edit"){
                editMode.toggle()
            }
            addButton
        })
        .onAppear(){
            print("fetch Data account on apper")
            viewModel.getListAccount()
        }
        .searchable(text: $viewModel.search)
        .onChange(of: viewModel .search) { newValue in
            print("fetch Data account on search")
            viewModel.getListAccount()
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
            Button("Yes", role: .destructive) {
                withAnimation {
                    viewModel.deleteAccount()
                    confirmationShown = false
                }
            }
            Button("Cancel", role: .cancel) {
                confirmationShown = false
            }
        }
    }
    
    private var addButton: some View {
        if(editMode){
            return AnyView(EmptyView())
        }
        
        return AnyView(
                Button(action: {
                    viewModel.newAccount()
                    showingModalView = true
                }){
                    Image(systemName: "plus")
                }
            )
    }

}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(state: AppState())
    }
}


struct AccountRow: View {
    let account: Account
    @Binding var editMode: Bool
    var body: some View {
        HStack{
            if editMode {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
            Text(account.name)
            Spacer()
        }
    }
}

