//
//  DashboardView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI

enum Tabs: String {
    case home
    case report
    case budget
    case more
    
    var description: String {
        get {
            switch self {
                case .home:
                    return "Home"
                case .report:
                    return "Report"
                case .budget:
                    return "Budget"
                case .more:
                    return "More"
            }
        }
    }
}

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var pushView = false
    @ObservedObject private var viewModel: SignInViewModel
    @State var selectedTab: Tabs = .home
    private let state: AppState
    
    init(state: AppState) {
        self.viewModel = SignInViewModel(authAPI: AuthService(), state: state)
        self.state = state
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(state: state)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tabs.home)

            ReportView(state: state)
                .tabItem {
                    Label("Report", systemImage: "chart.bar.xaxis")
                }
                .tag(Tabs.report)
            
            BudgetView(state: state)
                .tabItem {
                    Label("Budget", systemImage: "shippingbox")
                }
                .tag(Tabs.budget)
    
            MoreView(state: state)
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .tag(Tabs.more)
        }
        .accentColor(colorScheme == .light ? Color(UIConfiguration.tintColor) : .white)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(state.appSettings?.site_name ?? "")
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(state: AppState())
    }
}
