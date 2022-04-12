//
//  App.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 10/04/2022.
//

import SwiftUI

enum LoadingState {
    case visible
    case invisible
}

struct ListItem {
    let id: Int
    let name: String
    let image: String
    let color: Color
}
