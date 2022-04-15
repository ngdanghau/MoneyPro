//
//  TransactionModalView.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 14/04/2022.
//

import SwiftUI

struct TransactionModalView: View {
    private let state: AppState
    
    @State var amount: Double = 0
    @State private var searchText = ""

    init(state: AppState){
        self.state = state
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(state.appSettings?.currency ?? APIConfiguration.currency)
                    .foregroundColor(.gray)
                    .font(.system(size: 30))
                    .padding(.bottom, 20)
                    .padding(.trailing, -7)
                
                TextField(
                    "",
                    value: $amount,
                    formatter: CustomNumberField.numberFormater
                )
                    .multilineTextAlignment(.center)
                    .font(.system(size: 60))
                    .keyboardType(.decimalPad)
            }
            .padding(.bottom, -13)
            Rectangle()
                .foregroundColor(.gray)
                .frame(height: (2.5))
        }
        .fixedSize()
    }
}

struct TransactionModalView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionModalView(state: AppState())
    }
}
