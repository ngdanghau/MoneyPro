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
                VStack(alignment: .leading) {
                    Text("Host")
                    CustomTextField(
                        placeHolderText: "Host",
                        text: $viewModel.host,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
                VStack(alignment: .leading) {
                    Text("Port")
                    CustomTextField(
                        placeHolderText: "Port",
                        text: $viewModel.port,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }

                VStack(alignment: .leading) {
                    Picker("Encryption", selection: $viewModel.encryption) {
                          ForEach(Encryption.allCases) { encryption in
                              Text(encryption.rawValue).tag(encryption)
                          }
                    }
                }

                
                VStack(alignment: .leading) {
                    Text("From")
                    CustomTextField(
                        placeHolderText: "From",
                        text: $viewModel.from,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
                
                VStack(alignment: .leading) {
                    Toggle("Auth", isOn: $viewModel.auth)
                }
                
                
            }
            
            if viewModel.auth {
                Section(header: Text("Auth")){
                    VStack(alignment: .leading){
                        Text("Auth. username")
                        CustomTextField(
                            placeHolderText: "Auth. username",
                            text: $viewModel.username,
                            isPasswordType: false,
                            defaultStyle: true
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Auth. password")
                        CustomTextField(
                            placeHolderText: "Auth. password",
                            text: $viewModel.password,
                            isPasswordType: true,
                            defaultStyle: true
                        )
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
                ProgressView("Please wait...")
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
