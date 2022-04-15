//
//  EmailSettingView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 27/03/2022.
//

import SwiftUI

struct EmailSettingView: View {
    @ObservedObject private var viewModel: EmailSettingViewModel
    
    //isFetch is a variable that prevent onAppear run twice when we choose picker and return current view.
    @State private var isFetch: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    init(state: AppState){
        self.viewModel = EmailSettingViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        Form{
            Section(header: Text("Application")){
                HStack{
                    Text("Host")
                    TextField(
                        "Host",
                        text: $viewModel.host
                    )
                    .multilineTextAlignment(.trailing)
                }
                
                HStack{
                    Text("Port")
                    TextField(
                        "Port",
                        text: $viewModel.port
                    )
                    .multilineTextAlignment(.trailing)
                }

                VStack(alignment: .leading) {
                    Picker("Encryption", selection: $viewModel.encryption) {
                          ForEach(Encryption.allCases) { encryption in
                              Text(encryption.rawValue).tag(encryption)
                          }
                    }
                }

                
                HStack{
                    Text("From")
                    TextField(
                        "From",
                        text: $viewModel.from
                    )
                    .multilineTextAlignment(.trailing)
                }
                
                
                VStack(alignment: .leading) {
                    Toggle("Auth", isOn: $viewModel.auth)
                }
                
                
            }
            
            if viewModel.auth {
                Section(header: Text("Auth")){
                    HStack{
                        Text("Username")
                        TextField(
                            "Username",
                            text: $viewModel.username
                        )
                        .multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Text("Password")
                        SecureField(
                            "Password",
                            text: $viewModel.password
                        )
                        .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
        .navigationTitle("Email Setting")
        .toolbar {
            Button("Save") {
                UIApplication.shared.closeKeyboard()
                viewModel.updateEmailSettings()
            }
        }
        .overlay{
            if viewModel.loading == .visible {
                ProgressView("")
                  .progressViewStyle(CircularProgressViewStyle())
              }
        }
        .onAppear(){
            if isFetch {
                isFetch.toggle()
                print("fetchEmailSetting")
                viewModel.getEmailSetting()
            }
        }
        .alert(
            isPresented: self.$viewModel.isPresented
        ){
            Alert(title: Text(viewModel.statusViewModel?.title ?? ""),
                  message: Text(viewModel.statusViewModel?.message ?? ""),
                  dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                  })
            )
        }
    }
}

struct EmailSettingView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSettingView(state: AppState())
    }
}
