//
//  UIApplicationExt.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 03/04/2022.
//

import Foundation
import SwiftUI

extension UIApplication {
      func closeKeyboard() {
          sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
          )
      }
  }
 
