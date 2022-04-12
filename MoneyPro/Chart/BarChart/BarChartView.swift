//
//  BarChartView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 11/04/2022.
//

import SwiftUI



enum BarChartDateType: String, Identifiable, CaseIterable {
    case week
    case month
    case year
    
    var id: String { self.rawValue }
    
}


struct BarChartView: View {
    private var values: [ReportTotal]
    @State private var selection: Int = -1
    @State private var isActive: Int = 0
    @Binding private var dateType: BarChartDateType
    private var total: Double
    private var stringFormat: String
    var maxValue: Double = 0
    let formatter = DateFormatter()
    
    
    init(values: [ReportTotal], selection: Int, isActive: Int, dateType: Binding<BarChartDateType>, stringFormat: String, dateFormat: String, total: Double){
        self.values = values
        self.selection = selection
        self.isActive = isActive
        self._dateType = dateType
        self.stringFormat = stringFormat
        self.total = total
        
        if values.count > 0 {
            maxValue = values.map { $0.value }.max()!
        }
        formatter.dateFormat = dateFormat
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(String(format: stringFormat, selection > -1 ? values[selection].value : total))
                .bold()
                .font(.largeTitle)
            Text(selection > -1 ? "Spent on \(formatter.string(from: values[selection].date))" : "Total spent this \(dateType.rawValue)")
                .font(.body)
            
            GeometryReader { geometry in
                let fullBarHeight = geometry.size.height
                let width = geometry.size.width * 0.065
                ScrollView(.horizontal){
                    VStack{
                        HStack(alignment: .top){
                            ForEach(0..<self.values.count, id: \.self){ i in
                                BarColumnView(data: values[i], maxValue: maxValue, fullBarHeight: fullBarHeight, width: width, isActive: $isActive)
                                    .onTapGesture {
                                        if(selection == i) {
                                            if isActive == 0 {
                                                isActive = values[i].id
                                            }else {
                                                isActive = 0
                                            }
                                            selection = -1
                                        }else{
                                            isActive = values[i].id
                                            selection = i
                                        }
                                    }
                                    .animation(.default, value: 1)
                            }

                            VStack(alignment: .leading){
                                Text(String(format: "%.2f", maxValue))
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("0")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        
        .padding()
       
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        let data: [ReportTotal] = [
            ReportTotal(id: 2, date: Date(), name: "Mon", value: 120),
            ReportTotal(id: 3, date: Date(), name: "Tue", value: 70),
            ReportTotal(id: 4, date: Date(), name: "Wed", value: 10),
            ReportTotal(id: 5, date: Date(), name: "Thu", value: 20),
            ReportTotal(id: 6, date: Date(), name: "Fri", value: 40),
            ReportTotal(id: 7, date: Date(), name: "Sat", value: 60),
            ReportTotal(id: 8, date: Date(), name: "Sun", value: 100),
        ]
        BarChartView(values: data, selection: -1, isActive: 0, dateType: .constant(BarChartDateType.week), stringFormat: "%.2f", dateFormat: "ccc, LLL d", total: 120)
    }
}
