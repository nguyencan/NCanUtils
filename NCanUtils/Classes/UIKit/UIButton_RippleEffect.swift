//
//  UIButton_RippleEffect.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/8/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIButton {
    
    private static let rippleDefaultColor: UIColor = UIColor(hex: 0x55C2C2)
    
    private struct AssociatedKeys {
        static var rippleEffect: String = "NCanUtils+UIButton:rippleEffect"
        static var rippleOutBounds: String = "NCanUtils+UIButton:rippleOutBounds"
        static var rippleColor: String = "NCanUtils+UIButton:rippleColor"
        static var rippleLayer: String = "NCanUtils+UIButton:rippleLayer"
    }
    
    var rippleEffect: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleEffect) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleEffect, newValue as Bool, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var rippleOutBounds: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleOutBounds) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleOutBounds, newValue as Bool, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var rippleColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleColor) as? UIColor ?? UIButton.rippleDefaultColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleColor, newValue as UIColor, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: - UIButton:Ripple Effect
// Make ripple effect when touch on button
extension UIButton {
    
    private var rippleLayer: CAReplicatorLayer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleLayer) as? CAReplicatorLayer ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleLayer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        if rippleEffect, let touch = touch {
            let location = touch.location(in: self)
            if point(inside: location, with: nil) {
                displayRippleAnimation(location)
            }
        }
    }
    
    private func displayRippleAnimation(_ location: CGPoint) {
        let ripple = getAnimationMaskLayer()
        
        let circle = CALayer()
        circle.frame = calculateCircleAnimationFrame(location)
        circle.backgroundColor = rippleColor.alpha(0.5).cgColor
        circle.borderColor = nil
        circle.borderWidth = 0
        circle.cornerRadius = circle.frame.width / 2
        circle.masksToBounds = true
        ripple.addSublayer(circle)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = Double(1.0 / circle.frame.width)
        scale.toValue = 1
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0
        
        let group = CAAnimationGroup()
        group.delegate = LayerRemover(for: circle)
        group.duration = 0.5
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [scale, opacity]
        
        circle.add(group, forKey: "")
    }
    
    private func calculateCircleAnimationFrame(_ position: CGPoint) -> CGRect {
        let edge1: CGFloat
        if position.x > bounds.width - position.x {
            edge1 = position.x
        } else {
            edge1 = bounds.width - position.x
        }
        let edge2: CGFloat
        if position.y > bounds.height - position.y {
            edge2 = position.y
        } else {
            edge2 = bounds.height - position.y
        }
        var circleRadius: CGFloat = CGFloat(sqrt(pow(edge1, 2) + pow(edge2, 2))) + 4
        if rippleOutBounds && circleRadius > 36 {
            circleRadius = 36
        }
        
        return CGRect(x: position.x - circleRadius, y: position.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
    }
    
    private func getAnimationMaskLayer() -> CAReplicatorLayer {
        let result: CAReplicatorLayer
        let padding: CGFloat = getPadding()
        let layerFrame = CGRect(x: padding, y: padding, width: bounds.width - (2 * padding), height: bounds.height - (2 * padding))
        if let rl = rippleLayer {
            result = rl
        } else {
            let rl = CAReplicatorLayer()
            rl.frame = layerFrame
            layer.insertSublayer(rl, at: 0)
            
            result = rl
            rippleLayer = rl
        }
        result.frame = layerFrame
        result.cornerRadius = layer.cornerRadius
        if rippleOutBounds {
            result.masksToBounds = false
        } else {
            result.masksToBounds = true
        }
        result.instanceCount = 1
        result.instanceDelay = 0
        
        return result
    }
    
    private func getPadding() -> CGFloat {
        return 0
    }
}

private class LayerRemover: NSObject, CAAnimationDelegate {
    private weak var layer: CALayer?
    
    init(for layer: CALayer) {
        self.layer = layer
        super.init()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer?.backgroundColor = UIColor.clear.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.layer?.removeFromSuperlayer()
        }
    }
}

#endif
