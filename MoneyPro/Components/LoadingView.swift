//
//  LoadingView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 10/04/2022.
//


import SwiftUI

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content
    var text: String?
    
    var body: some View {
        GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        // the content to display - if the modal is showing, we'll blur it
                        content()
                            .disabled(isShowing)
                            .blur(radius: isShowing ? 2 : 0)
                        
                        // all contents inside here will only be shown when isShowing is true
                        if isShowing {
                            // this Rectangle is a semi-transparent black overlay
                            Rectangle()
                                .fill(Color.white).opacity(isShowing ? 0.3 : 0)
                                .edgesIgnoringSafeArea(.all)

                            VStack(spacing: 20) {
                                ProgressView().scaleEffect(2.0, anchor: .center)
                                Text(text ?? "Loading...")
                            }
                        }
                    }
                }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: .constant(Bool(true))){
            EmptyView()
        }
    }
}
