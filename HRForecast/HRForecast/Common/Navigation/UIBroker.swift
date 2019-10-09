//
//  UIBroker.swift
//  OmniMobileApp
//
//  Created by Vanaparthi, Ranjith on 6/7/18.
//  Copyright © 2018 U.S. Bank. All rights reserved.
//

import Foundation
import UIKit

struct UIBrokerConstants {
    static let brokerErrormessage = "Destination not implemeted UIBroker protocol"
}

typealias ClassName = String

@objc protocol UIBroker: class {
  /**
     Accepted all the data passed by last Controller.
     For exmpale:
     ```
     var payLoad:[String:Any]? {
     didSet {
     guard let payLoad = payLoad else { return }
     if payLoad.keys.contains("userDeatils")
     { self.userDeatils = userDeatils }
     }
     }
     var userDeatils:User?
     ```
     */
    var payLoad: [String: Any]? { get set }

    //Need for custom trasitions
    @objc optional func setCustomTransitions()
    @objc optional func backNavigationCallBack(result: Any?)
}   

extension UIViewController {

    //Navigate SourceVC to DestVC and pass payload
    func navigate(module: String, pushOrPresent: TransitionDecision, payLoad: [String: Any], pushPresentAnimated: Bool = true, schema: String? = nil, completion: ((_ vc: UIViewController) -> Void)? = nil) {

        let screen = module
        let moduleParam = schema ?? self.onlyClassName

        USBNavigator.shared.navigate(screen: screen,
                                                   module: moduleParam,
                                                   transition: pushOrPresent,
                                                   animated: pushPresentAnimated,
                                                   payload: payLoad,
                                                   completion: completion)
    }

    //  Back button navigation
    /// There are some scenarios where we have to send data to previous class,
    /// To Achieve this we are following default application architecture using UIBroker class.
    /// - Parameter result: to send object to super class.
    func backNavigation(_ result: AnyObject? = nil) {
        var payload: [String: Any]?
        if let res = result {
            payload = ["backNavPayload": res]
        }
        USBNavigator.shared.popViewController(payload: payload)
    }
    
    /// Use this function when we want to pop to a specific view controller in a navigation stack.
    ///
    /// - Parameters:
    ///   - type: the type of the controller we want to pop to (LoginViewController.self)
    ///   - animated: if the popping should be animated or not
    func backNavigationToViewController<T: UIViewController>(type: T.Type, animated: Bool) {
        USBNavigator.shared.popToViewController(type: type, animated: animated)
    }

    // Back to root view controller
    func backNavigationToRootViewController(animated: Bool = true) {
        USBNavigator.shared.popToRootViewController(animated: animated)
    }

    // Back to main view Controller
    // logic determain depends upon, first looks for quick action setup then looks for menu button screen as main land page.
    func backNavigationToMainLandViewController(animated: Bool = true) {
        USBNavigator.shared.popToMainLandingViewController(animated: animated)
    }

    //Dismiss the presented view instaed of dismiss view
    func dismissPresentedView(animated flag: Bool, trackDismiss: Bool = true, completion: (() -> Swift.Void)? = nil) {
        USBNavigator.shared.dismiss(self, animated: flag, trackDismiss: trackDismiss, completion: completion)
    }

    //Dismiss all presented views
    func dismissAllPresentedViews(animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        USBNavigator.shared.dismiss(self, all: true, animated: flag, completion: completion)
    }
}

extension UINavigationController: UIBroker {
    var payLoad: [String: Any]? {
        get {
            if let broker = self.viewControllers.first as? UIBroker {
                return broker.payLoad
            }
            return nil
        }
        set {
            if let broker = self.viewControllers.first as? UIBroker {
                broker.payLoad = newValue
            }
        }
    }
}
