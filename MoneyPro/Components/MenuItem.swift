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
            Image(systemName: item.image)
                .frame(width: 27, height: 27)
                .foregroundColor(.white)
                .background(item.color)
                .clipShape(
                    RoundedRectangle(cornerRadius: 5)
                )
            
            Text(item.name)
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(item: ListItem(id: 1, name: "test", image: "envelope.fill", color: .cyan))
    }
}
