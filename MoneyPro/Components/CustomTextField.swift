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
    private let defaultStyle: Bool
    
    init(placeHolderText: String, text: Binding<String>, isPasswordType: Bool = false, defaultStyle: Bool = true) {
        _text = text
        self.isPasswordType = isPasswordType
        self.placeHolderText = placeHolderText
        self.defaultStyle = defaultStyle
    }
    
    var body: some View {
        VStack {
            if isPasswordType {
                if defaultStyle {
                    SecureField(placeHolderText, text: $text)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                else {
                    SecureField(placeHolderText, text: $text)
                        .textFieldStyle(MyTextFieldStyle())
                }
                
            } else {
                if defaultStyle {
                    TextField(placeHolderText, text: $text)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                else {
                    TextField(placeHolderText, text: $text)
                        .textFieldStyle(MyTextFieldStyle())
                }
            }
        }
    }
}
