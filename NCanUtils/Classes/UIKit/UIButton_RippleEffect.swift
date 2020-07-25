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
    
    private struct AssociatedKeys {
        static var rippleEffect: String = "NCanUtils+UIButton:rippleEffect"
        static var rippleOutBounds: String = "NCanUtils+UIButton:rippleOutBounds"
        static var rippleColor: String = "NCanUtils+UIButton:rippleColor"
    }
    
    var rippleEffect: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleEffect) as? Bool ?? CNManager.shared.style.button.rippleEffect
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
            return objc_getAssociatedObject(self, &AssociatedKeys.rippleColor) as? UIColor ?? CNManager.shared.style.button.rippleColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rippleColor, newValue as UIColor, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: - UIButton:RippleEffect
// Make ripple effect when touch on button
extension UIButton {

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        if rippleEffect, let touch = touch {
            let location = touch.location(in: self)
            if point(inside: location, with: nil) {
                
                displayRippleAnimation(location, color: rippleColor, isOutBounds: rippleOutBounds)
            }
        }
    }
}

class LayerRemover: NSObject, CAAnimationDelegate {
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

// MARK: - UIView:RippleEffect
extension UIView {
    
    private static let rippleLayerName = "NCanUtils:RippleLayerName"

    func displayRippleAnimation(_ location: CGPoint, color: UIColor, isOutBounds: Bool) {
        let rippleMaskLayer = getRippleAnimationMaskLayer()
        if isOutBounds {
            rippleMaskLayer.masksToBounds = false
        } else {
            rippleMaskLayer.masksToBounds = true
        }
        let animatedLayer = CALayer()
        animatedLayer.frame = calculateRippleAnimationFrame(location, rippleOutBounds: isOutBounds)
        animatedLayer.backgroundColor = color.alpha(0.5).cgColor
        animatedLayer.borderColor = nil
        animatedLayer.borderWidth = 0
        animatedLayer.cornerRadius = animatedLayer.frame.width / 2
        animatedLayer.masksToBounds = true
        rippleMaskLayer.addSublayer(animatedLayer)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = Double(1.0 / animatedLayer.frame.width)
        scale.toValue = 1
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0
        
        let group = CAAnimationGroup()
        group.delegate = LayerRemover(for: animatedLayer)
        group.duration = 0.5
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.animations = [scale, opacity]
        
        animatedLayer.add(group, forKey: "")
    }
    
    private func getRippleAnimationMaskLayer() -> CAReplicatorLayer {
        let result: CAReplicatorLayer
        let padding: CGFloat = getRipplePadding()
        let layerFrame = CGRect(x: padding, y: padding, width: bounds.width - (2 * padding), height: bounds.height - (2 * padding))
        if let rl = findRippleLayer() {
            result = rl
        } else {
            let rl = CAReplicatorLayer()
            rl.frame = layerFrame
            layer.insertSublayer(rl, at: 0)
            
            result = rl
        }
        result.frame = layerFrame
        result.cornerRadius = layer.cornerRadius
        if #available(iOS 11.0, *) {
            result.maskedCorners = layer.maskedCorners
        }
        result.shadowPath = layer.shadowPath
        result.instanceCount = 1
        result.instanceDelay = 0
        
        return result
    }
    
    private func findRippleLayer() -> CAReplicatorLayer? {
        if let layers = self.layer.sublayers {
            for item in layers {
                if UIView.rippleLayerName == item.name, let result = item as? CAReplicatorLayer {
                    return result
                }
            }
        }
        return nil
    }
    
    private func calculateRippleAnimationFrame(_ position: CGPoint, rippleOutBounds: Bool, minRadius: CGFloat = 36) -> CGRect {
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
        if rippleOutBounds && circleRadius > minRadius {
            circleRadius = minRadius
        }
        
        return CGRect(x: position.x - circleRadius, y: position.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
    }
    
    func getRipplePadding() -> CGFloat {
        if let view = self as? DesignableButton {
            if !view.border.colors.isEmpty {
                return view.border.width
            }
         } else {
            if layer.borderColor != nil {
                return layer.borderWidth
            }
         }
        return 0
    }
}

#endif
