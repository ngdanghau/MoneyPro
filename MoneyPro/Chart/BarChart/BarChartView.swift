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
    @Binding private var selection: Int
    @State private var isActive: Int = 0
    public let title: () -> String
    public let subTitle: () -> String

    var maxValue: Double = 0
    var color: Color
    
    init(
        values: [ReportTotal],
        selection: Binding<Int>,
        title: @escaping () -> String,
        subTitle: @escaping () -> String,
        color: Color = .blue
    ){
        self.values = values
        if values.count > 0 {
            maxValue = values.map { $0.value }.max()!
        }
        self.title = title
        self.subTitle = subTitle
        self._selection = selection
        self.color = color
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title())
                .bold()
                .font(.largeTitle)
            Text(subTitle())
                .font(.body)
                .foregroundColor(.gray)

            GeometryReader { geometry in
                let fullBarHeight = geometry.size.height
                let width = geometry.size.width * 0.055
                ScrollView(.horizontal){
                    VStack{
                        HStack(alignment: .top){
                            ForEach(0..<self.values.count, id: \.self){ i in
                                BarColumnView(data: values[i], maxValue: maxValue, fullBarHeight: fullBarHeight, width: width, isActive: $isActive, color: color)
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
                                Text(Helpers.readableFileSize(number: Int(maxValue)))
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
        BarChartView(
            values: data, selection: .constant(Int(0)),
            title: {
                return String("100")
            },
            subTitle: {
                return String("")
            }
        )
    }
}
