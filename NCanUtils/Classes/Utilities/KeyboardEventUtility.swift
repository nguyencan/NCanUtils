//
//  KeyboardEventUtility.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/26/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)
import UIKit

// MARK: - UIViewController:PUBLIC
extension UIViewController {
    
    /// NCanUtils: Remove keyboard listener
    ///
    /// - Call in viewDidDisappear of UIViewController
    ///
    public func removeKeyboardEvent() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    /// NCanUtils: Register keyboard listener
    ///
    /// - Call in viewWillAppear of UIViewController
    ///
    public func registerKeyboardEvent(_ scrollView: UIScrollView?, bottomBar: (view: UIView, height: CGFloat)? = nil, tapOutToHide: Bool = true) {
        self.scroller = scrollView
        self.bottomBar = bottomBar
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        if tapOutToHide {
            _ = hideKeyboardWhenTappedAround()
        }
    }
    
    public func hideKeyboardWhenTappedAround() -> UITapGestureRecognizer {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandleKeyboardEvent))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        return tap
    }
}

// MARK: - UIViewController:VARIABLE
extension UIViewController {
    
    private struct AssociatedKeys {
        static var scroller: String = "NCanUtils+UIViewController:scroller"
        static var bottomBar: String = "NCanUtils+UIViewController:bottomBar"
    }
    
    private var scroller: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.scroller) as? UIScrollView ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.scroller, newValue as UIScrollView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var bottomBar: (view: UIView, height: CGFloat)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.bottomBar) as? (view: UIView, height: CGFloat) ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.bottomBar, newValue as (view: UIView, height: CGFloat)?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: - UIViewController:PRIVATE
extension UIViewController {
    
    @objc func tapHandleKeyboardEvent(_ sender: UITapGestureRecognizer) {
        if let _ = sender.getTouchedInputView() {
            return
        }
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            if notification.name == UIResponder.keyboardWillShowNotification {
                // Hide bottom bar
                if let bottom = bottomBar, bottom.height > 0 {
                    bottom.view.alpha = 0
                    if let constraint = getHeightConstraint(bottom.view) {
                        constraint.constant = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // Wait for hidden bottom bar then change view's frame
                        if let window = self.view.window?.frame {
                            // We're not just minusing the kb height from the view height because
                            // the view could already have been resized for the keyboard before
                            let height: CGFloat = (window.height - self.view.frame.origin.y) - keyboardFrame.height
                            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                                     y: self.view.frame.origin.y,
                                                     width: self.view.frame.width,
                                                     height: height)
                        }
                    }
                } else {
                    if let window = self.view.window?.frame {
                        // We're not just minusing the kb height from the view height because
                        // the view could already have been resized for the keyboard before
                        let height: CGFloat = (window.height - self.view.frame.origin.y) - keyboardFrame.height
                        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                                 y: self.view.frame.origin.y,
                                                 width: self.view.frame.width,
                                                 height: height)
                    }
                }
            } else if notification.name == UIResponder.keyboardDidShowNotification {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let scroller = self.scroller, let firstResponsder = scroller.firstResponder {
                        let rect = self.getInputFrame(firstResponsder, parent: scroller)
                        scroller.scrollRectToVisible(rect, animated: true)
                    }
                }
            } else if notification.name == UIResponder.keyboardWillHideNotification {
                // No need check height window with scroll view
                if let window = self.view.window?.frame {
                    let height: CGFloat = (window.height - self.view.frame.origin.y)
                    if height <= window.height {
                        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                                 y: self.view.frame.origin.y,
                                                 width: self.view.frame.width,
                                                 height: height)
                    }
                }
                // Show bottom bar
                if let bottom = bottomBar, bottom.height > 0 {
                    if let constraint = getHeightConstraint(bottom.view) {
                        constraint.constant = bottom.height
                    }
                    bottom.view.alpha = 1
                }
            }
        }
    }
    
    private func getInputFrame(_ child: UIView, parent: UIView) -> CGRect {
        let rect: CGRect = child.frame
        let origin = child.convert(rect.origin, to: parent)
        
        return CGRect(origin: origin, size: CGSize(width: rect.width, height: rect.height + 8))
    }
    
    private func getHeightConstraint(_ view: UIView) -> NSLayoutConstraint? {
        return view.constraints.filter { (constraint) -> Bool in
            if let firstItem = constraint.firstItem as? UIView, firstItem == view, constraint.firstAttribute == .height, constraint.secondItem == nil {
                return true
            }
            return false
            }.first
    }
}

// MARK: - UITapGestureRecognizer:PRIVATE
extension UITapGestureRecognizer {
    
    fileprivate func getTouchedInputView() -> UIView? {
        if let view = view {
            let location = self.location(in: view)
            let inputViews = view.getInputViews()
            for inputView in inputViews {
                let frame = inputView.convert(inputView.frame, to: view)
                if frame.contains(location) {
                    return inputView
                }
            }
        }
        return nil
    }
}

// MARK: - UIView:PRIVATE
extension UIView {
    
    fileprivate func getInputViews() -> [UIView] {
        var result: [UIView] = []
        for subview in self.subviews {
            if let _ = subview as? UIKeyInput {
                if subview.isUserInteractionEnabled, !subview.isHidden, subview.alpha > 0 {
                    result.append(subview)
                }
            } else {
                for subSubview in subview.subviews {
                    result.append(contentsOf: subSubview.getInputViews())
                }
            }
        }
        return result
    }
}

#endif
