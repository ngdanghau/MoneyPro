//
//  ArrayExt.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 01/04/2022.
//

import SwiftUI

extension Array where Element: Equatable {
    @discardableResult
    public mutating func replace(_ element: Element, with new: Element) -> Bool {
        if let f = self.firstIndex(where: { $0 == element}) {
            self[f] = new
            return true
        }
        return false
    }
}
