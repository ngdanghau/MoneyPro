//
//  CustomTextField.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    private let isPasswordType: Bool
    private let placeHolderText: String
    
    init(placeHolderText: String, text: Binding<String>, isPasswordType: Bool = false) {
        _text = text
        self.isPasswordType = isPasswordType
        self.placeHolderText = placeHolderText
    }
    
    var body: some View {
        VStack {
            if isPasswordType {
                SecureField(placeHolderText, text: $text)
                    .textFieldStyle(MyTextFieldStyle())
                
            } else {
                TextField(placeHolderText, text: $text)
                    .textFieldStyle(MyTextFieldStyle())
            }
        }
    }
}
