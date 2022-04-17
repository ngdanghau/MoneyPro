//
//  BarColumnView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 10/04/2022.
//

import SwiftUI

struct BarColumnView: View {
    var data: ReportTotal
    var maxValue: Double
    var fullBarHeight: Double
    var width: Double
    var color: Color

    @Binding var isActive: Int
    private let radius: Double = 5.0
    
    init(data: ReportTotal, maxValue: Double, fullBarHeight: Double, width: Double, isActive: Binding<Int>, color: Color = .blue){
        self.data = data
        self.maxValue = maxValue
        self.fullBarHeight = fullBarHeight
        self.width = width
        self._isActive = isActive
        self.color = color
    }

    var body: some View {
        let value = maxValue > 0 ? (Double(fullBarHeight) / maxValue) * data.value : 0
        
        VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.gray.opacity(isActive == data.id ? 0.5 : 0.2))
                    .frame(width: width, height: fullBarHeight)
                
                RoundedRectangle(cornerRadius: radius)
                    .fill(color)
                    .frame(width: width, height: value)

            }
            Text(data.name)
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 4)
    }
}


struct BarColumnView_Previews: PreviewProvider {
    static var previews: some View {
        let data = ReportTotal(id: 1, date: Date(), name: "Mon", value: 1000)
        BarColumnView(data: data, maxValue: 1200, fullBarHeight: 500, width: 12, isActive: .constant(Int(0)))
    }
}
