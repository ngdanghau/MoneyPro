//
//  MoreView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI

struct MoreView: View {
    @AppStorage ("colorSchemeApp") private var colorSchemeApp: SchemeSystem = .light
    private let state: AppState
    init(state: AppState) {
        self.state = state
    }
        
    var body: some View {
        List{
            Section(header: Text("Profile")){
                ForEach(state.authUser?.getListItem() ?? [], id: \.id){
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
                    }
                }
                
            }
            
            Section(header: Text("General")){
                ForEach(state.authUser?.getListItemGeneral() ?? [], id: \.id){
                    item in
                    NavigationLink(destination: destinationView(indexView: item.id, state: self.state)){
                        MenuItem(item: item)
                    }
                }
            }
            
            if state.authUser?.getListItemAdmin().count ?? 0 > 0{
                Section(header: Text("Admin")){
                    ForEach(state.authUser?.getListItemAdmin() ?? [], id: \.id){
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
                    state.removeAccessToken()
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

