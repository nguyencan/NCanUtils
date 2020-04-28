//
//  UIViewController_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties
public extension UIViewController {

    /// NCanUtils: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
}

// MARK: - Methods
extension UIViewController {
    
    public func showAsActionSheet(_ target: UIViewController, background: UIView?, content: UIView?) {
        background?.alpha = 0
        content?.alpha = 0
        target.present(self, animated: false) {
            if let content = content {
                self.animationShowActionSheet(background, content: content)
            } else {
                background?.alpha = 1
                content?.alpha = 1
            }
        }
    }
    
    public func dismissActionSheet(_ background: UIView?, complete: (() -> Void)? = nil) {
        background?.alpha = 0
        self.dismiss(animated: true) {
            complete?()
        }
    }
    
    private func animationShowActionSheet(_ background: UIView?, content: UIView) {
        let animationStartOffset: CGFloat = -400.0
        let animationDuration: TimeInterval = 0.2
        
        let animationEndOrigin = content.frame.origin
        let animationStartOrigin = CGPoint(x: animationEndOrigin.x, y: content.frame.origin.y - animationStartOffset)
        
        content.frame.origin = animationStartOrigin
        background?.alpha = 0
        content.alpha = 1
        UIView.animate(withDuration: animationDuration) {
            background?.alpha = 1
            content.frame.origin = animationEndOrigin
        }
    }
    
    /// NCanUtils: Show share providers popup with message
    ///
    /// - Parameter message: String
    func openShareProviders(_ message: String) {
        // Show share providers
        let controller = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = self.view
        present(controller, animated: true, completion: nil)
    }
}

#endif
