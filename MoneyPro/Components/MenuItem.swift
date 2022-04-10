//
//  MenuItem.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 28/03/2022.
//

import SwiftUI

struct MenuItem: View {
    var item: ListItem
    var body: some View {
        HStack{
            ZStack {
                Rectangle()
                    .frame(width: 30, height: 30)
                    .cornerRadius(7)
                    .foregroundColor(item.color)
                
                Image(systemName: item.image)
                    .foregroundColor(.white)
            }
            
            Text(item.name)
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(item: ListItem(id: 1, name: "test", image: "envelope.fill", color: .cyan))
    }
}
