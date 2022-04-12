//
//  UserManagementView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 06/04/2022.
//

import SwiftUI

struct UserManagementView: View {
    @ObservedObject private var viewModel: UserManagementViewModel
        
    @State private var editMode: Bool = false
    @State private var showingModalView = false
    
    @State var confirmationShown: Bool = false
            
    init(state: AppState){
        viewModel = UserManagementViewModel(authAPI: AuthService(), state: state)
    }

    var body: some View {
        List {
            ForEach(viewModel.users) { item in
                UserRow(
                    user: item,
                    editMode: $editMode,
                    confirmationShown: $confirmationShown
                )
                .onTapGesture {
                    viewModel.setUser(user: item)
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
                                viewModel.setUser(user: item)
                                confirmationShown = true
                            }
                        ){
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            
            if viewModel.recordsTotal != viewModel.users.count  {
                Section{
                    Button(action: {
                        print("fetch Data user load more")
                        viewModel.getNextListUser()
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
                ProgressView("Please wait...")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
        .fullScreenCover(isPresented: $showingModalView) {
            ModalUserManagementView( viewModel: viewModel)
        }
        .navigationBarTitle("Users", displayMode: .inline)
        .navigationBarItems(trailing: HStack{
            Button(editMode ? "Done" : "Edit"){
                editMode.toggle()
            }
            addButton
        })
        .onAppear(){
            print("fetch Data user on apper")
            viewModel.getListUser()
        }
        .searchable(text: $viewModel.search)
        .onSubmit(of: .search) {
            print("fetch Data user on search")
            viewModel.getListUser()
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
                    viewModel.deleteUser()
                    confirmationShown = false
                }
            }
            Button("No", role: .cancel) {
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
                    viewModel.newUser()
                    showingModalView = true
                }){
                    Image(systemName: "plus")
                }
            )
    }

}

struct UserManagementView_Previews: PreviewProvider {
    static var previews: some View {
        UserManagementView(state: AppState())
    }
}


struct UserRow: View {
    let user: User
    @Binding var editMode: Bool
    @Binding var confirmationShown: Bool
    var body: some View {
        HStack{
            if editMode {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading){
                HStack{
                    Text(user.firstname + " " + user.lastname)
                    if user.account_type == .admin {
                        Image(systemName: "shield")
                            .foregroundColor(.purple)
                    }
                }
                Text(user.email)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    .italic()
            }
            Spacer()
            if user.is_active {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }else {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
            }
        }
        
    }
}

