//
//  DesignableButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/8/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class DesignableButton: UIButton {
    
    private struct AssociatedKeys {
        static var border: String = "NCanUtils+DesignableButton:border"
        static var corners: String = "NCanUtils+DesignableButton:corners"
        static var background: String = "NCanUtils+DesignableButton:background"
        static var shadowSpread: String = "NCanUtils+DesignableButton:shadowSpread"
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
                return CornerStyle(radius: cornerRadius)
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
    
    public override var isHighlighted: Bool {
        didSet {
            let alpha: CGFloat
            if isHighlighted && isEnabled {
                alpha = CNManager.shared.style.button.highlightedAlpha
            } else {
                alpha = 1
            }
            imageView?.alpha = alpha
            titleLabel?.alpha = alpha
        }
    }
    
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

// MARK: - DesignableButton:Shadow
public extension DesignableButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
        
    }
    
    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable var shadowSpread: CGFloat {
        get {
            return layer.shadowSpread
        }
        set {
            layer.shadowSpread = newValue
        }
    }
}

#endif
