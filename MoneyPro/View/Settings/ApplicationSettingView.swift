//
//  ApplicationSettingView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 28/03/2022.
//

import SwiftUI

struct ApplicationSettingView: View {
    @ObservedObject private var viewModel: ApplicationSettingViewModel
    
    //isFetch is a variable that prevent onAppear run twice when we choose picker and return current view.
    @State private var isFetch: Bool = true
    
    @Environment(\.presentationMode) var presentationMode
    
    init(state: AppState){
        self.viewModel = ApplicationSettingViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        Form{
            Section(header: Text("Application")){
                VStack(alignment: .leading) {
                    Text("Site Name")
                    CustomTextField(
                        placeHolderText: "Site Name",
                        text: $viewModel.site_name,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
                VStack(alignment: .leading) {
                    Text("Site Slogan")
                    CustomTextEditor(
                        text: $viewModel.site_slogan
                    )
                }

                VStack(alignment: .leading) {
                    Text("Site Description")
                    CustomTextEditor(
                        text: $viewModel.site_description
                    )
                }

                VStack(alignment: .leading) {
                    Text("Site Keywords")
                    CustomTextEditor(
                        text: $viewModel.site_keywords
                    )
                }
            }
            
            Section (header: Text("Logo")){
                VStack(alignment: .leading) {
                    Text("Logotype")
                    CustomTextField(
                        placeHolderText: "Logotype",
                        text: $viewModel.logotype,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }

                VStack(alignment: .leading) {
                    Text("Logomark")
                    CustomTextField(
                        placeHolderText: "Logomark",
                        text: $viewModel.logomark,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }
            }
            
            Section (header: Text("Other")){
                VStack(alignment: .leading) {
                    Text("Currency")
                    CustomTextField(
                        placeHolderText: "Currency",
                        text: $viewModel.currency,
                        isPasswordType: false,
                        defaultStyle: true
                    )
                }


                VStack(alignment: .leading) {
                    Picker("Language", selection: $viewModel.language) {
                        List {
                            ForEach(Language.allCases) { language in
                                Text(language.description).tag(language)
                            }
                        }
                      }
                }
            }
        }
        .navigationTitle("Application Setting")
        .toolbar {
            Button("Save") {
                UIApplication.shared.closeKeyboard()
                viewModel.updateAppSettings()
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
                print("fetchDataSetting")
                viewModel.getDataSetting()
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

struct ApplicationSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationSettingView(state: AppState())
    }
}
