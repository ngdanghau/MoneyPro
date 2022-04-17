//
//  ColorSchemePickerView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 17/04/2022.
//

import SwiftUI

struct ColorSchemePickerView: View {
    @Binding var colorScheme: SchemeSystem
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ColorSchemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePickerView(colorScheme: .constant(.dark))
    }
}
