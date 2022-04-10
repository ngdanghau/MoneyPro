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
