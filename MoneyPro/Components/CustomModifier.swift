//
//  CustomModifier.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import SwiftUI


import SwiftUI

struct TextModifier: ViewModifier {
    private let color: UIColor
    
    init(color: UIColor = .black) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(Color(color))
            .multilineTextAlignment(.center)
            .lineLimit(nil)
    }
}

struct ShadowModifier: ViewModifier {
    let color: UIColor
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(color), radius: 5.0, x: 3, y: 3)
    }
}

struct ButtonModifier: ViewModifier {
    private let color: UIColor
    private let textColor: UIColor
    private let width: CGFloat?
    private let height: CGFloat?
    
    init(color: UIColor,
         textColor: UIColor = .white,
         width: CGFloat? = nil,
         height: CGFloat? = nil) {
        self.color = color
        self.textColor = textColor
        self.width = width
        self.height = height
    }
    
    func body(content: Content) -> some View {
        content
            .modifier(TextModifier(color: textColor))
            .padding()
            .frame(width: width, height: height)
            .background(Color(color))
            .cornerRadius(25.0)
    }
}


struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 25,
                                 style: .continuous)
                    .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct DefaultTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
            )
            .padding(.bottom, 10)
    }
}
