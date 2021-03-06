//
//  MoreView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI

struct MoreView: View {
    @AppStorage ("accountType") private var accountType: AccountType = .member
    @AppStorage ("siteName") private var siteName: String = ""

    @State private var colorSchemeApp: SchemeSystem

    private let state: AppState
    
    private let menuProfile: [ListItem] = [
        ListItem(id: 1, name: "Account Details", image: "person.crop.circle", color: .indigo),
        ListItem(id: 2, name: "Change Password", image: "key", color: .blue)
    ]
    
    private let menuGeneral: [ListItem] = [
        ListItem(id: 3, name: "Accounts", image: "creditcard", color: .orange),
        ListItem(id: 4, name: "Categories", image: "list.bullet", color: .mint),
        ListItem(id: 5, name: "Goals", image: "target", color: .red)
    ]
    
    private let menuAdmin: [ListItem] = [
        ListItem(id: 6, name: "Application Settings", image: "gear", color: .purple),
        ListItem(id: 7, name: "Email Settings", image: "mail", color: .green),
        ListItem(id: 8, name: "User Management", image: "person.2.fill", color: .pink)
    ]
    
    init(state: AppState) {
        self.state = state
        if let color = state.colorSheme {
            self.colorSchemeApp = color == "system" ? .system : ( color == "light" ? .light : .dark )
        }else {
            self.colorSchemeApp = .system
        }
        
    }
        
    var body: some View {
        List{
            Section(header: Text("Profile")){
                ForEach(menuProfile, id: \.id){
                    item in
                    NavigationLink(destination: destinationView(indexView: item.id, state: self.state)){
                        MenuItem(item: item)
                    }
                }
            }
            
            Section(header: Text("System")){
                HStack{
                    Image(systemName: "moon.fill")
                        .frame(width: 27, height: 27)
                        .foregroundColor(.white)
                        .background(.gray)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                    
                    Picker("Appeanrance", selection: $colorSchemeApp){
                        ForEach(SchemeSystem.allCases) { colorScheme in
                            Text(colorScheme.description).tag(colorScheme)
                        }
                        .onChange(of: colorSchemeApp){ newValue in
                            state.colorSheme = colorSchemeApp.id
                            ThemeManager.shared.handleTheme(darkMode: colorSchemeApp != .light, system: colorSchemeApp == .system)
                            
                        }
                    }
                }
                
            }
            
            Section(header: Text("General")){
                ForEach(menuGeneral, id: \.id){
                    item in
                    NavigationLink(destination: destinationView(indexView: item.id, state: self.state)){
                        MenuItem(item: item)
                    }
                }
            }
            
            if accountType == .admin {
                Section(header: Text("Admin")){
                    ForEach(menuAdmin, id: \.id){
                        item in
                        NavigationLink(destination: destinationView(indexView: item.id, state: self.state)){
                            MenuItem(item: item)
                        }
                    }
                }
            }
            
            
            HStack{
                MenuItem(item: ListItem(id: 5, name: "Rate app on AppStore", image: "star.fill", color: .orange))
                Spacer()
                Image(systemName: "chevron.forward").foregroundColor(.gray)
            }
            
            HStack{
                MenuItem(item: ListItem(id: 5, name: "Share with Friends", image: "arrowshape.turn.up.right.fill", color: .blue))
                Spacer()
                Image(systemName: "chevron.forward").foregroundColor(.gray)
            }.onTapGesture {
                actionSheet()
            }
            
            
            
            Section{
                Button(action: {
                    state.accessToken = nil
                    accountType = .member
                    siteName = ""
                    NavigationUtil.popToRootView()
                }){
                    Text("Log Out")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
    
    private func destinationView(indexView: Int, state: AppState) -> AnyView {
        switch indexView{
        case 1:
            return AnyView(AccountDetails(state: state))
        case 2:
            return AnyView(ChangePassword(state: state))
            
        case 3:
            return AnyView(AccountView(state: state))
        case 4:
            return AnyView(CategoryView(state: state))
        case 5:
            return AnyView(GoalView(state: state))
            
        case 6:
            return AnyView(ApplicationSettingView(state: state))
        case 7:
            return AnyView(EmailSettingView(state: state))
        case 8:
            return AnyView(UserManagementView(state: state))
            
        default:
            actionSheet()
            return AnyView(EmptyView())
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(activityVC, animated: true, completion: nil)
   }
    
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(state: AppState())
    }
}

