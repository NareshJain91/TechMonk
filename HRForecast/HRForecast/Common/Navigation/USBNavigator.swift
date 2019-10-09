//
//  USBNavigator.swift
//  OmniMobileApp
//
//  Created by Ramirez Pastor, Jose Antonio on 7/17/19.
//  Copyright © 2019 U.S. Bank. All rights reserved.
//

import Foundation
import UIKit

public enum TransitionDecision {
    case push
    case present
    // TODO: - Do we need to handle the child VC as part of UIBroker?
    case child
}

class USBNavigator {

    static let shared = USBNavigator()

    private let errorTopMost = "Failed to get the Top most navigation controller"

    private init() {
        // intensionally left blank..
    }

    /// Method to navigate from one screen to the next one.
    ///
    /// - Parameters:
    ///   - screen:
    ///   - module:
    ///   - transition: (Optional) The transition style to use when navigating to the view controller. If not present, defaults to .push
    ///         * .push - will push the ViewController to current NavigationController
    ///         * .present - will present as a modal the ViewController already embedded in a new NavigationController.
    ///   - animated: (Optional) Pass true to animate the transition; otherwise, pass false. If not present, defaults to true.
    ///   - payload: (Optional) Dictionary of the type [String: Any] sent to the destination ViewController. Defaults to nil if not present.
    ///   - completion: (Optional) The block to execute after the presentation finishes. This block has no return value and takes UIViewController as a parameter. Defaults to nil
    func navigate(screen: String, module: String, transition: TransitionDecision = .push, animated: Bool = true, payload: [String: Any]? = nil, completion: ((_ vc: UIViewController) -> Void)? = nil) {

        // Get the destination VC and source VC
        guard let destinationBroker = self.getViewController(screen: screen, module: module),
            let destinationVC = destinationBroker as? UIViewController,
            let sourceVC = UIViewController.top else {
            LogUtil.logError("Failed to get the source (and/or) destination view controller instance.")
            return
        }

        destinationBroker.payLoad = payload
        destinationBroker.setCustomTransitions?()

        switch transition {
        case .present:
            // TODO: Subclass UINavigationController to extend functionality
            /*var nav = UINavigationController(rootViewController: vc)
            setupNavigationController(&nav)
            topNav.present(nav, animated: animated, completion: completion)*/
            sourceVC.present(destinationVC, animated: animated, completion: nil)

        case .push:
            guard let topNav = getTopNavController() else { return }
            topNav.pushViewController(destinationVC, animated: animated)

        case .child:
            addChildVC(sourceVC: sourceVC, destinationVC: destinationVC)
        }

        // TODO: - Discusson the completion params.
        if let complitionhandle = completion {
            complitionhandle(destinationVC)
        }
    }

    /// Pops the top view controller from the navigation stack and updates the display.
    ///
    /// - Parameters:
    ///   - animated: (Optional) Pass true to animate the transition; otherwise, pass false. If not present, defaults to true.
    ///   - payload: (Optional) Dictionary of the type [String: Any] sent to the destination ViewController.
    func popViewController(animated: Bool = true, payload: [String: Any]? = nil) {

        // Get the top navigation controller
        guard let topNav = self.getTopNavController() else {
            LogUtil.logError(errorTopMost)
            return
        }

        // check if the pop is allowed
        // if the count is 1 or less, you're in Root VC
        // Hence, pop is not allowed
        let count = topNav.children.count
        guard count > 1, let currentVC = topNav.children.last else {
            LogUtil.logError("Reached the root view controller. Pop not allowed.")
            return
        }

        // Pop the view controller
        topNav.popViewController(animated: animated)

        // Perform all necessary navigation steps
        let destinationVC = topNav.children[count - 2]
        
        // Get the destination as UIBroker
        guard let destBroker = destinationVC as? UIBroker else { return }

        // Assign (or) Merge the payload to the destination VC
        if let destPayload = destBroker.payLoad {
            if let backPayload = payload {
                var existingPayload = destPayload
                existingPayload.merge(backPayload) { (_, new) in new }
                destBroker.payLoad = existingPayload
            }
        } else {
            destBroker.payLoad = payload
        }

        // Backward compatiblility to support existing method.
        if let callBack = destBroker.backNavigationCallBack {
            if let pl = payload, let oldBack = pl["backNavPayload"] {
                callBack(oldBack)
            } else {
                callBack(nil)
            }
        }
    }

    /// Pops the top view controller to a specific view controller in stack
    ///
    /// - Parameters:
    ///   - type: Type of the class to navigate to.
    ///   - animated: (Optional) Pass true to animate the transition; otherwise, pass false. If not present, defaults to true.
    // TODO: - Check if the method needs a return value
    @discardableResult
    func popToViewController<T: UIViewController>(type: T.Type, animated: Bool = true) -> Bool {

        // Get the top navigation controller
        guard let topNav = self.getTopNavController(),
            let currentVC = topNav.children.last else {
            LogUtil.logError(errorTopMost)
            return false
        }

        for viewController in topNav.children.reversed() where viewController is T {
            topNav.popToViewController(viewController, animated: true)
            return true
        }
        return false
    }

    /// Pops the top view controller to the root view controller of the navigation controller
    ///
    /// - Parameters:
    ///   - animated: (Optional) Pass true to animate the transition; otherwise, pass false. If not present, defaults to true.
    func popToRootViewController(animated: Bool = true) {

        // Get the top navigation controller
        guard let topNav = self.getTopNavController(),
            let rootVC = topNav.children.first,
            let currentVC = topNav.children.last else {
                LogUtil.logError(errorTopMost)
                return
        }
        topNav.popToRootViewController(animated: animated)
    }

    /// Pops the top view controller to the main landing view controller of the current flow
    /// Landing view is identified using QuickAction Protocol or Command Center 
    ///
    /// - Parameters:
    ///   - animated: (Optional) Pass true to animate the transition; otherwise, pass false. If not present, defaults to true.
    func popToMainLandingViewController(animated: Bool = true) {

        // Get the top navigation controller
        guard let topNav = self.getTopNavController(),
            let currentVC = topNav.children.last else {
            LogUtil.logError("Failed to get the Top most navigation controller")
            return
        }

        popToRootViewController(animated: animated)
    }

    /// Dismisses the view controller that was presented modally by the view controller.
    ///
    /// - Parameters:
    ///   - all: (Optional) Pass true to dismiss all presented ViewControllers
    ///   - animated: (Optional) Pass true to animate the transition; otherwise, pass false. If not present, defaults to true.
    ///   - payload: (Optional) Dictionary of the type [String: Any] sent to the presentingViewController.
    ///   - completion: (Optional) The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func dismiss(_ vc: UIViewController? = nil, all: Bool = false, animated: Bool = true, trackDismiss: Bool = true, completion: (() -> Void)? = nil) {

        guard let currentVC = (vc != nil ) ? vc : UIViewController.top else {
            return
        }

        if all {

            if let window = currentVC.view.window,
                let rootView = window.rootViewController {
                window.rootViewController?.dismiss(animated: animated, completion: completion)
            }

        } else {
            currentVC.dismiss(animated: animated, completion: completion)
        }
    }

    // Method to show to activity indicator with top reference
    func showActivityIndicator() {
        guard let vc = UIViewController.top as? BaseViewController else {
            return
        }
        vc.showActivityIndicator()
    }

    // Method to hide to activity indicator with top reference
    func hideActivityIndicator() {
        guard let vc = UIViewController.top as? BaseViewController else {
            return
        }
        vc.hideActivityIndicator()
    }

    // MARK: - Private methods.
    // Add the destination VC as a child
    private func addChildVC(sourceVC: UIViewController, destinationVC: UIViewController) {
        sourceVC.addChild(destinationVC)
        sourceVC.view.addSubview(destinationVC.view)
        destinationVC.didMove(toParent: sourceVC)
    }

    // Get the destination screen as a UIBroker object
    private func getViewController(screen: String, module: String) -> UIBroker? {
        guard let screenPath = readFromPlist(screen: screen, module: module) else {
            return nil
        }
        if checkStoryBoardOrNot(name: screenPath) {
            let components = screenPath.components(separatedBy: ".")
            guard let storyboardName = components.first,
                let storyboardIdentifier = components.last else {
                LogUtil.logError("Couldn't find Storyboard.")
                return nil
            }

            let storyboard = UIStoryboard(name: String(storyboardName), bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: String(storyboardIdentifier)) as? UIBroker else {
                LogUtil.logError("VC does not conform to UIBroker.")
                return nil
            }
            return vc
        } else {
            guard let genericClassType  = getClassType(from: screenPath) else {
                return nil
            }
            let viewController = genericClassType.init()
            guard let uiBroker = viewController as? UIBroker else {
                return nil
            }
            return uiBroker
        }
    }

    // Get the UIViewController name from Navigation plist
    private func readFromPlist(screen: String, module: String) -> String? {
        LogUtil.logInfo("Looking for screen *\(screen)* in module *\(module)*")
        var flowList: NSDictionary?
        if let path = Bundle.main.path(forResource: GlobalConstants.navigationFileName, ofType: "plist") {
            flowList = NSDictionary(contentsOfFile: path)
            if let dict = flowList,
                let screenPathDict = dict[module] as? [String: Any],
                let screenPath = screenPathDict[screen] as? String {
                LogUtil.logInfo("Found path *\(screenPath)*")
                return screenPath
            }
        }
        LogUtil.logError("Could not find path.")
        return nil
    }

    /// takes the class name and gives class.Type
    ///
    /// - Parameter name: class name
    /// - Returns: NSObject.Type?
    private func getClassType(from name: String) -> NSObject.Type? {
        guard let topViewController = UIViewController.top,
            let appModule = topViewController.className.components(separatedBy: ".").first else {
            return nil
        }
        //getting class type from string "appModule+className" ex:  "USBank.BusinessLendingCategoryViewController"
        if let classType = NSClassFromString(appModule + "." + name) as? NSObject.Type {
            return classType
        }
        return nil
    }

    //checking stroryboard existing or not
    private func checkStoryBoardOrNot(name: String) -> Bool {
        // In Navigation.plist, the format is as
        // <storyboardName>.<storyboardIdentier>
        let data = name.components(separatedBy: ".")

        // if the count is 2, we have the value in
        // standard format in plist.
        if data.count == 2 {
            return true
        }

        // there are some case, where above
        // format is not followed
        return false
    }

    // To get the navigation controller of the top most VC
    // TODO: - Change this to use mainNavController after
    // we implement the main navigation stack
    private func getTopNavController() -> UINavigationController? {
        guard let vc = UIViewController.top,
            let navController = vc.navigationController else {
                // TODO: - Change to proper dismiss method. 
                dismiss(all: true, animated: false, trackDismiss: false)
                return UIViewController.navRoot ?? UINavigationController()
        }
        return navController
    }
}

#if DEBUG
// MARK: - public methods to be accessed from XCTests
extension USBNavigator {
    func testGetViewController(screen: String, module: String) -> UIBroker? {
        return getViewController(screen: screen, module: module)
    }

    func storyboardCheck(name: String) -> Bool {
        return checkStoryBoardOrNot(name: name)
    }
}
#endif
