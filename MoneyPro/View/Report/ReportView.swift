//
//  ReportView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 29/03/2022.
//

import SwiftUI

struct ReportView: View {
    @ObservedObject private var viewModelReport: ReportViewModel
    @ObservedObject private var viewModelCategoryReport: CategoryReportViewModel
    @ObservedObject private var viewModelTransactionReport: TransactionReportViewModel

    @State private var currentTab: BarChartDateType = .week
    @Namespace private var animation
    
    @State private var isShowListTransaction: Bool = false
    @State private var type: String = "income"
    @State private var state: AppState = AppState()
    @State private var categoryInfo: CategoryReportTotal = CategoryReportTotal(id: 0, name: "", color: "", amount: 0, total: 0)
    
    init(state: AppState){
        self.state = state
        self.viewModelReport = ReportViewModel(authAPI: AuthService(), state: state)
        self.viewModelCategoryReport = CategoryReportViewModel(authAPI: AuthService(), state: state)
        self.viewModelTransactionReport = TransactionReportViewModel(authAPI: AuthService(), state: state)
    }
    
    
    
    var body: some View {
        VStack{
            BarChartView(
                values: viewModelReport.values,
                selection: -1,
                isActive: 0,
                dateType: $currentTab,
                stringFormat: "\(viewModelReport.response?.currency ?? "") %.2f",
                dateFormat: getDateFormat(),
                total: getTotalTransaction()
            )
                .frame(height: 200)
            
            HStack(spacing: 0){
                ForEach(BarChartDateType.allCases){ barChartDateType in
                    TabButton(currentType: barChartDateType, animation: animation, currentTab: $currentTab)
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            Divider()
            
            VStack{
                NavigationLink("",
                               destination: TransactionListView(
                                state: state,
                                category: categoryInfo,
                                date: viewModelCategoryReport.response?.date ?? ReportDate(from: Date(), to: Date()),
                                currency: viewModelCategoryReport.response?.currency ?? ""
                               ),
                               isActive: $isShowListTransaction
                )
                ScrollView(.vertical){
                    ForEach(viewModelCategoryReport.values, id: \.id){ category in
                        CategoryRowReport(category: category, currency: viewModelCategoryReport.response?.currency ?? "")
                            .onTapGesture {
                                categoryInfo = category
                                isShowListTransaction = true
                            }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear(){
            viewModelReport.getData(type: type, date: currentTab)
            viewModelTransactionReport.getData(type: type, date: currentTab)
            viewModelCategoryReport.getData(type: type, date: currentTab)
        }
        .overlay{
            if viewModelReport.loading == .visible || viewModelCategoryReport.loading == .visible || viewModelTransactionReport.loading == .visible {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onChange(of: currentTab) { newValue in
            viewModelReport.getData(type: type, date: currentTab)
            viewModelCategoryReport.getData(type: type, date: currentTab)
        }
    }
    
    private func getDateFormat() -> String {
        switch currentTab {
        case .week:
            return "ccc, LLL d"
        case .month:
            return "MMMM, YYYY"
        case .year:
            return "YYYY"
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
                .foregroundColor(currentTab == currentType ? .black : .gray)
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
    
    var category: CategoryReportTotal
    var currency: String
    
    var body: some View {
        HStack{
            Rectangle()
                .foregroundColor(Color(UIColor(hexString: category.color)))
                .frame(width: 25, height: 25)
                .cornerRadius(7)
            Text(category.name)
                .fontWeight(.medium)
            
            Text(String(format: "x%d", category.total))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(String(format: "\(currency)%.2f", category.amount))
        }
        Divider()
    }
}
