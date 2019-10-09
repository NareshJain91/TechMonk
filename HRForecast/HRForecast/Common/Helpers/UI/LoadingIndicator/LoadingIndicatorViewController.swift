//
//  LoadingIndicatorViewController.swift
//  HRForecast
//
//  Created by Vamsi Katragadda on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingIndicatorViewController: class {
    var loadingIndicator: UIActivityIndicatorView { get set }
    var newWindow: UIWindow? { get set }
    func showActivityIndicator(delay: Double)
    func hideActivityIndicator()
}

struct LoadingIndicatorViewControllerHelper {
    static var window: UIWindow?
    static var loadingIndicator: UIActivityIndicatorView = ActivityIndicatorView()
    static var finishedQuickly = false
}

extension LoadingIndicatorViewController {

    var newWindow: UIWindow? {
        get {
            return LoadingIndicatorViewControllerHelper.window
        } set {
            LoadingIndicatorViewControllerHelper.window = newValue
        }
    }

    var loadingIndicator: UIActivityIndicatorView {
        get {
            return LoadingIndicatorViewControllerHelper.loadingIndicator
        } set {
            LoadingIndicatorViewControllerHelper.loadingIndicator = newValue
        }
    }

    func showActivityIndicator(delay: Double = 0.5) {
        LoadingIndicatorViewControllerHelper.finishedQuickly = false
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            //Guard needs to be here in the case that the network call finished quickly
            guard self.newWindow == nil && !LoadingIndicatorViewControllerHelper.finishedQuickly else { return }
            let loadingIndicatorWindow = UIWindow(frame: UIScreen.main.bounds)//CGRect.init(x: 0, y: 0, width: 1200, height: 1200))
            self.newWindow = loadingIndicatorWindow
            loadingIndicatorWindow.windowLevel = UIWindow.Level.alert + 1
            loadingIndicatorWindow.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            loadingIndicatorWindow.makeKeyAndVisible()
            loadingIndicatorWindow.addSubview(self.loadingIndicator)
            self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.loadingIndicator.centerXAnchor.constraint(equalTo: loadingIndicatorWindow.centerXAnchor).isActive = true
            self.loadingIndicator.centerYAnchor.constraint(equalTo: loadingIndicatorWindow.centerYAnchor).isActive = true
            self.loadingIndicator.startAnimating()
        }
    }

    func hideActivityIndicator() {
        LoadingIndicatorViewControllerHelper.finishedQuickly = true
        //The subviews for UIWindow is either a default view if no subviews are added, or just the subviews that have been added with no default view
        //Since we know that at least the loading indicator will be a subview of the window, we get the subviews, then filter out the loading indicator
        //The only views left are the subviews we want to transfer over
        let currentSubviewsToTransfer = self.newWindow?.subviews.filter { $0 !== self.loadingIndicator }
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.removeFromSuperview()
        self.newWindow?.backgroundColor = .clear
        self.newWindow?.superview?.removeFromSuperview()
        self.newWindow = nil
        currentSubviewsToTransfer?.forEach { UIApplication.shared.delegate?.window??.addSubview($0) }
    }
}
