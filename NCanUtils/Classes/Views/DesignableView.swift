//
//  UIView_Designable.swift
//  NCanUtils
//
//  Created by SG on 7/9/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public class DesignableView: UIView {
    
    private struct AssociatedKeys {
        static var border: String = "NCanUtils+DesignableView:border"
        static var corners: String = "NCanUtils+DesignableView:corners"
        static var background: String = "NCanUtils+DesignableView:background"
    }
    
    var border: BorderStyle {
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
    
    var corners: CornerStyle {
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
    
    public var background: BackgroundStyle {
        get {
            if let result = (objc_getAssociatedObject(self, &AssociatedKeys.background) as? BackgroundStyle) {
                return result
            } else if let color = backgroundColor {
                return BackgroundStyle(colors: [color])
            } else {
                return BackgroundStyle()
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.background, newValue as BackgroundStyle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            if !newValue.colors.isEmpty {
                backgroundColor = .clear
            }
            setNeedsLayout()
        }
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            if let color = backgroundColor, color != .clear {
                background = BackgroundStyle(colors: [color])
            }
        }
    }
    
    public override func draw(_ rect: CGRect) {
        // Draw round corners
        addRoundCorners(corners.corners, radius: corners.radius)
        // Draw background if needs
        drawBackgroundIfNeeds(colors: background.colors, direction: background.direction, radius: corners.radius, corners: corners.corners)
        // Draw border if needs
        drawBorderIfNeeds(colors: border.colors, lineWidth: border.width, dashLength: border.length, dashSpace: border.space, radius: corners.radius, corners: corners.corners)
        
        super.draw(rect)
    }
}

#endif
