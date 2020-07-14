//
//  DesignableControl.swift
//  NCanUtils
//
//  Created by SG on 7/14/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

open class DesignableControl: UIControl {
    
    private struct AssociatedKeys {
        static var rippleEffect: String = "NCanUtils+UIButton:rippleEffect"
        static var rippleOutBounds: String = "NCanUtils+UIButton:rippleOutBounds"
        static var rippleColor: String = "NCanUtils+UIButton:rippleColor"
    }
    
    public var rippleEffect: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleEffect) as? Bool ?? CNManager.shared.style.rippleEffect
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleEffect, newValue as Bool, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var rippleOutBounds: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleOutBounds) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleOutBounds, newValue as Bool, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var rippleColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleColor) as? UIColor ?? CNManager.shared.style.rippleColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleColor, newValue as UIColor, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open var highlightedTags: [Int] {
        get {
            return []
        }
    }
    
    private var isTouching: Bool = false
}

// MARK: - Highlight Effect
extension DesignableControl {

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let position = touch.location(in: self)
            if bounds.contains(position) {
                showHighlight(true)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        var inside: Bool = false
        if let touch = touches.first {
            let position = touch.location(in: self)
            if bounds.contains(position) && isTouching {
                inside = true
            }
        }
        if !inside {
            showHighlight(false)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        showHighlight(false)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        showHighlight(false)
    }
    
    private func showHighlight(_ isHighlighted: Bool) {
        isTouching = isHighlighted
        DispatchQueue.main.async {
            if isHighlighted && self.isEnabled {
                for tag in self.highlightedTags {
                    self.viewWithTag(tag)?.alpha = CNManager.shared.style.highlightedAlpha
                }
            } else {
                for tag in self.highlightedTags {
                    self.viewWithTag(tag)?.alpha = 1.0
                }
            }
        }
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        if rippleEffect, let touch = touch {
            let location = touch.location(in: self)
            if point(inside: location, with: nil) {
                displayRippleAnimation(location, color: rippleColor, isOutBounds: rippleOutBounds)
            }
        }
    }
}

#endif
