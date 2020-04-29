//
//  AppRouteUtility.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)  && !os(watchOS)
import UIKit

// MARK: - UIStoryboard
public extension UIStoryboard {

    /// NCanUtils: Get main storyboard for application
    static var main: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }

    /// NCanUtils: Instantiate a UIViewController using its class name
    ///
    /// - Parameter name: UIViewController type
    /// - Returns: The view controller corresponding to specified class name
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }

}

// MARK: - UIApplication
public extension UIApplication {
    
    /// NCanUtils: Check if root view is a UIViewController using its class name
    ///
    /// - Parameter name: UIViewController type
    /// - Returns: true if UIViewController's class is root view
    static func isBaseOnMainView<T: UIViewController>(withClass name: T.Type) -> Bool {
        if let window  = getWindow()
            , let _ = window.rootViewController as? T {
            return true
        }
        return false
    }
    
    /// NCanUtils: Switch app root view to a UIViewController using its class identifier
    ///
    /// - Parameter identifier: UIViewController identifier
    /// - Parameter storyboard: KStoryboard. Default is Main.storyboard
    static func switchRootView(identifier: String, storyboard: KStoryboard = .main) {
        // switch root view controllers
        if let window = getWindow() {
            let nav = storyboard.viewControllerFor(identifier)
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
    
    /// NCanUtils: Switch app root view to a UIViewController using its class name
    ///
    /// - Parameter identifier: UIViewController Type
    /// - Parameter storyboard: KStoryboard. Default is Main.storyboard
    static func switchRootView<T: UIViewController>(withClass name: T.Type, storyboard: KStoryboard = .main) {
        // switch root view controllers
        switchRootView(identifier: name.storyboardID, storyboard: storyboard)
    }
    
    static func getWindow() -> UIWindow? {
        let window: UIWindow?
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneWindow = scene.windows.first {
            window = sceneWindow
        } else if let appWindow = UIApplication.shared.delegate?.window {
            window = appWindow
        } else {
            window = nil
        }
        return window
    }
    
    static func openSettingApp() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - KStoryboard
public enum KStoryboard: String {
    
    case main = "Main"
    case admin = "Admin"
    case staff = "Staff"
    case client = "Client"
    case launch = "LaunchScreen"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    /// NCanUtils: Instantiate a UIViewController using its class name
    ///
    /// - Parameter name: UIViewController type
    /// - Returns: The view controller corresponding to specified class name
    public func viewController<T: UIViewController>(_ viewControllerClass: T.Type) -> T {
        let identifier = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    /// NCanUtils: Instantiate a UIViewController using its class identifier
    ///
    /// - Parameter name: UIViewController identifier
    /// - Returns: The view controller corresponding to specified class identifier
    public func viewControllerFor(_ identifier: String) -> UIViewController? {
        return instance.instantiateViewController(withIdentifier: identifier)
    }
    
    /// NCanUtils: Instantiate a UIViewController
    ///
    /// - Parameter name: UIViewController type
    /// - Returns: The view controller corresponding to root of storyboard
    public func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

// MARK: - UIViewController
public extension UIViewController {
    
    /// Storyboard identifier: Needs paste Class name into Identity[Storyboard ID] in Storyboard
    class var storyboardID: String {
        return "\(self)"
    }
    
    /// NCanUtils: Instantiate a UIViewController
    ///
    /// - Parameter storyboard: KStoryboard
    /// - Returns: The view controller
    static func initFromKStoryboard(_ storyboard: KStoryboard) -> Self {
        return storyboard.viewController(self)
    }
}

#endif
