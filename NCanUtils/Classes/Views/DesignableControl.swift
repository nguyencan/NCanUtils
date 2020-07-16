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
        static var border: String = "NCanUtils+DesignableControl:border"
        static var corners: String = "NCanUtils+DesignableControl:corners"
        static var background: String = "NCanUtils+DesignableControl:background"
        static var shadowSpread: String = "NCanUtils+DesignableControl:shadowSpread"
        
        static var rippleEffect: String = "NCanUtils+DesignableControl:rippleEffect"
        static var rippleOutBounds: String = "NCanUtils+DesignableControl:rippleOutBounds"
        static var rippleColor: String = "NCanUtils+DesignableControl:rippleColor"
    }
    
    public var rippleEffect: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleEffect) as? Bool ?? CNManager.shared.style.button.rippleEffect
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
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleColor) as? UIColor ?? CNManager.shared.style.button.rippleColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleColor, newValue as UIColor, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var border: BorderStyle {
        get {
            if let result = objc_getAssociatedObject(self, &AssociatedKeys.border) as? BorderStyle {
                return result
            } else {
                var result = BorderStyle()
                if let color = layer.borderColor, color != UIColor.clear.cgColor {
                    result.colors = [UIColor(cgColor: color)]
                }
                result.width = layer.borderWidth
                return result
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.border, newValue as BorderStyle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            setNeedsLayout()
        }
    }
    
    public var corners: CornerStyle {
        get {
            if let result = objc_getAssociatedObject(self, &AssociatedKeys.corners) as? CornerStyle {
                return result
            } else {
                return CornerStyle(radius: layer.cornerRadius)
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.corners, newValue as CornerStyle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            setNeedsLayout()
        }
    }
    
    public var background: GradientStyle {
        get {
            if let result = (objc_getAssociatedObject(self, &AssociatedKeys.background) as? GradientStyle) {
                return result
            } else if let color = backgroundColor {
                return GradientStyle(colors: [color])
            } else {
                return GradientStyle()
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.background, newValue as GradientStyle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            if !newValue.colors.isEmpty {
                backgroundColor = .clear
            }
            setNeedsLayout()
        }
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            if let color = backgroundColor, color != .clear {
                background = GradientStyle(colors: [color])
            }
        }
    }

    private var isTouching: Bool = false
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Draw round corners
        addRoundCorners(corners.corners, radius: corners.radius)
        // Draw background if needs
        drawBackgroundIfNeeds(style: background, rounded: corners)
        // Draw border if needs
        drawBorderIfNeeds(style: border, rounded: corners)
    }
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
    
    public func showHighlight(_ isHighlighted: Bool) {
        isTouching = isHighlighted
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
