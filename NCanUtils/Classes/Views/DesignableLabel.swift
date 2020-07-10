//
//  DesignableLabel.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/9/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public class DesignableLabel: UILabel {
    
    private struct AssociatedKeys {
        static var border: String = "NCanUtils+DesignableLabel:border"
        static var corners: String = "NCanUtils+DesignableLabel:corners"
        static var background: String = "NCanUtils+DesignableLabel:background"
        static var textInsets: String = "NCanUtils+DesignableLabel:textInsets"
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
    
    public var textInsets: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.textInsets) as? UIEdgeInsets ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.textInsets, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            invalidateIntrinsicContentSize()
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
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if let insets = textInsets, insets != .zero {
            contentSize.width += insets.left + insets.right
            contentSize.height += insets.top + insets.bottom
        }
        return contentSize
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        if let insets = textInsets, insets != .zero {
            adjSize.width += insets.left + insets.right
            adjSize.height += insets.top + insets.bottom
        }
        return adjSize
    }

    override public func draw(_ rect: CGRect) {
        // Draw round corners
        addRoundCorners(corners.corners, radius: corners.radius)
        // Draw background if needs
        drawBackgroundIfNeeds(colors: background.colors, direction: background.direction, radius: corners.radius, corners: corners.corners)
        // Draw border if needs
        drawBorderIfNeeds(colors: border.colors, lineWidth: border.width, dashLength: border.length, dashSpace: border.space, radius: corners.radius, corners: corners.corners)
        
        super.draw(rect)
    }
    
    public override func drawText(in rect: CGRect) {
        // Redraw text with insets
        if let insets = textInsets, insets != .zero {
            super.drawText(in: rect.inset(by: insets))
        } else {
            super.drawText(in: rect)
        }
    }
}

#endif
