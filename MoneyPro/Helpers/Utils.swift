//
//  NavigationUtil.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 26/03/2022.
//

import UIKit

struct NavigationUtil {
    static func popToRootView() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.filter { $0.isKeyWindow }.first

        findNavigationController(viewController: window?.rootViewController)?
            .popToRootViewController(animated: true)
    }

    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }

        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }

        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }

        return nil
    }
}

/**
 * Convert size in byte to human readable text
 *
 * @param  integer  $size      size in bytes
 * @param  integer $precision
 * @return string|bool
 */
struct Helpers {
    static func readableFileSize(number: Int) -> String {
        var real_number: Double = Double(number)
        if number < 0 {
            real_number = 0
        }
        
        let unit: [String] = ["", "k", "M", "G", "T", "P", "E"]
        let step: Double = 1000
        var i: Int = 0

        let max = unit.count - 1
        
        while real_number > 999 {
            real_number = real_number / step;
            i += 1

           if i > max {
               break;
           }
        }
        
        return "\(round(real_number * 100) / 100)\(unit[i])"
    }
}
