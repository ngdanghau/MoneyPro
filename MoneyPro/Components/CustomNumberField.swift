//
//  CustomNumberField.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 14/04/2022.
//

import SwiftUI

struct CustomNumberField: View {
    
    @Binding var value: Double
    private let placeHolderText: String
    private let defaultStyle: Bool
    
    static var numberFormater: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }
    
    init(placeHolderText: String, value: Binding<Double>,  defaultStyle: Bool = true) {
        self._value = value
        self.placeHolderText = placeHolderText
        self.defaultStyle = defaultStyle
    }
    
    var body: some View {
        VStack {
            if defaultStyle {
                TextField(placeHolderText, value: $value, formatter: CustomNumberField.numberFormater)
                    .textFieldStyle(DefaultTextFieldStyle())
            }
            else {
                TextField(placeHolderText, value: $value, formatter: CustomNumberField.numberFormater)
                    .textFieldStyle(MyTextFieldStyle())
            }
        }
    }
}
