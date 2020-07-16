//
//  UIView_Designable.swift
//  NCanUtils
//
//  Created by SG on 7/9/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

open class DesignableView: UIView {
    
    private struct AssociatedKeys {
        static var border: String = "NCanUtils+DesignableView:border"
        static var corners: String = "NCanUtils+DesignableView:corners"
        static var background: String = "NCanUtils+DesignableView:background"
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
    
    public override func draw(_ rect: CGRect) {
        // Draw round corners
        addRoundCorners(corners.corners, radius: corners.radius)
        // Draw background if needs
        drawBackgroundIfNeeds(style: background, rounded: corners)
        // Draw border if needs
        drawBorderIfNeeds(style: border, rounded: corners)
        
        super.draw(rect)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

#endif
