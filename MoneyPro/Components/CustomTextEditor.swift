//
//  DefaultTextEditor.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 28/03/2022.
//

import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String
    
    init(text: Binding<String>) {
        _text = text
    }
    
    var body: some View {
        TextEditor(
            text: $text
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
        )
        .frame(height: 120, alignment: .leading)
        .padding(.bottom, 10)
    }
}
