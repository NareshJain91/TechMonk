//
//  UIViewControllerExtension.swift
//  OmniMobileApp
//
//  Created by Sundarrajan, Vivekanandhan on 4/13/18.
//  Copyright © 2018 U.S. Bank. All rights reserved.
//

import UIKit

public extension UIViewController {

    static let barButtonDefaultOffset = 16
    static let barButtonOffset = -16
    static let buttonSpacer = 25

    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }

    func setNavigationBarHidden(animaed: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animaed)
    }

    func setTranslucentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    func setNavigationBarColor(_ color: UIColor?, textColor: UIColor? = nil, font: UIFont? = nil) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.isTranslucent = false

        if let color = textColor, let textfont = font {
            let attributes = [NSAttributedString.Key.foregroundColor: color,
                              NSAttributedString.Key.font: textfont]
            self.navigationController?.navigationBar.titleTextAttributes = attributes
        }
    }
}

extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

extension UIViewController {
    static var top: UIViewController? {
        return topViewController()
    }

    static var navRoot: UINavigationController? {
        return UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
    }

    static var root: UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }

    static func topViewController(from viewController: UIViewController? = UIViewController.root) -> UIViewController? {
        var resultVC: UIViewController? = viewController
        if let tabBarViewController = viewController as? UITabBarController {
            resultVC = topViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            resultVC = topViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            resultVC = topViewController(from: presentedViewController)
        }
        return resultVC
    }
}
