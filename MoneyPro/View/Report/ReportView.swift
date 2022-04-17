//
//  ReportView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 29/03/2022.
//

import SwiftUI

struct ReportView: View {
    private let state: AppState
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject private var viewModelReport: ReportViewModel
    @ObservedObject private var viewModelCategoryReport: CategoryReportViewModel
    @ObservedObject private var viewModelTransactionReport: TransactionReportViewModel

    @State private var currentTab: BarChartDateType = .week
    @Namespace private var animation
    
    @State private var selection: Int = -1
    @State private var isShowListTransaction: Bool = false
    @State private var currentType: MoneyType = .income
    @State private var categoryInfo: CategoryReportTotal = CategoryReportTotal(id: 0, name: "", color: "", amount: 0, total: 0)
    private let formatter = DateFormatter()

    init(state: AppState){
        self.state = state
        self.viewModelReport = ReportViewModel(authAPI: AuthService(), state: state)
        self.viewModelCategoryReport = CategoryReportViewModel(authAPI: AuthService(), state: state)
        self.viewModelTransactionReport = TransactionReportViewModel(authAPI: AuthService(), state: state)
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Menu {
                    ForEach(MoneyType.allCases) { moneyType in
                        if moneyType != .none {
                            Button(action: {
                                currentType.toggle()
                            }, label: {
                                if currentType == moneyType {
                                    Label(moneyType.description, systemImage: "checkmark")
                                }else{
                                    Text(moneyType.description)
                                }
                            }).tag(moneyType)
                        }
                        
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .font(.system(size: 25))
                .foregroundColor(colorScheme == .light ? .black : .white)
            }
            .padding(.horizontal)
            BarChartView(
                values: viewModelReport.values,
                selection: $selection,
                title: {
                    if selection > -1 {
                        return "\(state.appSettings?.currency ?? APIConfiguration.currency)\(viewModelReport.values[selection].value.withCommas())"
                    }
                    else {
                        return "\(state.appSettings?.currency ?? APIConfiguration.currency)\(getTotalTransaction().withCommas())"
                    }
                },
                subTitle: {
                    if selection > -1 {
                        return "\(currentType == .income ? "Earned" : "Spent") on \(getDateString(date: viewModelReport.values[selection].date))"
                    }
                    else {
                        return "Total \(currentType == .income ? "earned" : "spent") this \(currentTab.rawValue)"
                    }
                },
                color: currentType == .income ? .green : .blue
            )
                .frame(height: 230)
                .overlay{
                    if viewModelReport.loading == .visible || viewModelTransactionReport.loading == .visible {
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            
            HStack(spacing: 0){
                ForEach(BarChartDateType.allCases){ barChartDateType in
                    TabButton(currentType: barChartDateType, animation: animation, currentTab: $currentTab)
                }
            }
            .padding(.all)
            Divider()
            
            VStack{
                NavigationLink("",
                               destination: TransactionListView(
                                state: state,
                                category: categoryInfo,
                                date: viewModelCategoryReport.response?.date ?? ReportDate(from: Date(), to: Date()),
                                currency: state.appSettings?.currency ?? APIConfiguration.currency
                               ),
                               isActive: $isShowListTransaction
                )
                ScrollView(.vertical){
                    ForEach(viewModelCategoryReport.values, id: \.id){ category in
                        Button(action: {
                            categoryInfo = category
                            isShowListTransaction = true
                        }, label: {
                            CategoryRowReport(category: category, currency: state.appSettings?.currency ?? APIConfiguration.currency)
                        })
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                }
            }
            .padding(.horizontal)
            .overlay{
                if  viewModelCategoryReport.loading == .visible {
                    ProgressView("")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            Spacer()
        }
        .onAppear(){
            loadData()
        }
        .onChange(of: currentTab) { newValue in
            loadData()
        }
        .onChange(of: currentType) { newValue in
            loadData()
        }
        .onDisappear(){
            selection = -1
        }
    }
    
    private func loadData() -> Void {
        selection = -1
        viewModelReport.getData(type: currentType, date: currentTab)
        viewModelTransactionReport.getData(type: currentType, date: currentTab)
        viewModelCategoryReport.getData(type: currentType, date: currentTab)
    }
    
    private func getDateString(date: Date) -> String {
        
        switch currentTab {
        case .week:
            formatter.dateFormat = "ccc, LLL d"
            return formatter.string(from: date)
        case .month:
            formatter.dateFormat = "MMMM, YYYY"
            return formatter.string(from: date)
        case .year:
            formatter.dateFormat = "YYYY"
            return formatter.string(from: date)
        }
    }
    
    private func getTotalTransaction() -> Double{
        switch currentTab {
        case .week:
            return viewModelTransactionReport.values.week
        case .month:
            return viewModelTransactionReport.values.month
        case .year:
            return viewModelTransactionReport.values.year
        }
        
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(state: AppState())
    }
}



struct TabButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var currentType: BarChartDateType
    var animation: Namespace.ID
    
    @Binding var currentTab: BarChartDateType
    
    var body: some View {
        Button{
            withAnimation(.spring()){
                currentTab = currentType
            }
        }label: {
            Text(currentType.rawValue.capitalized)
                .foregroundColor(currentTab == currentType ? colorScheme == .light ? .black : .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    ZStack{
                        if currentTab == currentType {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                )
        }
    }
}

struct CategoryRowReport: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var category: CategoryReportTotal
    var currency: String
    
    var body: some View {
        HStack{
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(UIColor(hexString: category.color)))
                    .frame(width: 25, height: 25)
            }
            .padding(.bottom, 15)
            
            VStack{
                HStack{
                    Text(category.name)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    
                    Text("x\(category.total.withCommas())")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(currency)\(category.amount.withCommas())")
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    
                }
                Divider()
            }
        }
    }
}


