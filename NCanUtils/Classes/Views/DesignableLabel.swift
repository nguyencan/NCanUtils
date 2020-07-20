//
//  DesignableLabel.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/9/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

open class DesignableLabel: UILabel {
    
    private struct AssociatedKeys {
        static var border: String = "NCanUtils+DesignableLabel:border"
        static var corners: String = "NCanUtils+DesignableLabel:corners"
        static var background: String = "NCanUtils+DesignableLabel:background"
        static var textInsets: String = "NCanUtils+DesignableLabel:textInsets"
        static var textColors: String = "NCanUtils+DesignableLabel:textColors"
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
    
    public var textColors: GradientStyle {
        get {
            if let result = (objc_getAssociatedObject(self, &AssociatedKeys.textColors) as? GradientStyle) {
                return result
            } else if let color = textColor {
                return GradientStyle(colors: [color])
            } else {
                return GradientStyle()
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.textColors, newValue as GradientStyle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            setNeedsLayout()
        }
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            if let color = backgroundColor, color != .clear {
                background.colors = [color]
            }
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        guard let text = self.text, let textInsets = textInsets else {
            return contentSize
        }
        let insetsHeight: CGFloat = textInsets.vertical
        let insetsWidth: CGFloat = textInsets.horizontal
        if let font = self.font {
            let textWidth: CGFloat = frame.size.width - insetsWidth
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = self.textAlignment
            paragraph.paragraphSpacingBefore = 0
            paragraph.paragraphSpacing = 0
            paragraph.minimumLineHeight = font.lineHeight
            paragraph.maximumLineHeight = font.lineHeight
            let newSize = text.boundingRect(
                with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font, .paragraphStyle: paragraph],
                context: nil)

            contentSize.height = ceil(newSize.size.height) + insetsHeight
            contentSize.width = ceil(newSize.size.width) + insetsWidth
        } else {
            contentSize.width += insetsWidth
            contentSize.height += insetsHeight
        }
        return contentSize
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        // Refresh content size after frame's changed
        invalidateIntrinsicContentSize()
    }

    override public func draw(_ rect: CGRect) {
        // Draw round corners
        addRoundCorners(corners.corners, radius: corners.radius)
        // Draw background if needs
        drawBackgroundIfNeeds(style: background, rounded: corners)
        // Draw border if needs
        drawBorderIfNeeds(style: border, rounded: corners)
        
        super.draw(rect)
    }
    
    public override func drawText(in rect: CGRect) {
        let textRect = getTextRect(in: rect)
        // Prepare gradient text color
        let colorRect: CGRect
        if let insets = textInsets {
            colorRect = CGRect(
                x: textRect.origin.x,
                y: textRect.origin.y,
                width: textRect.size.width + insets.right,
                height: textRect.size.height
            )
        } else {
            colorRect = textRect
        }
        if let color = generateLinearGradientColor(colors: textColors.colors, direction: textColors.direction, rect: colorRect) {
            self.textColor = color
        }
        // Redraw text with insets
        super.drawText(in: textRect)
    }
    
    private func getTextRect(in rect: CGRect) -> CGRect {
        var result: CGRect = rect
        if let insets = textInsets {
            result = rect.inset(by: insets)
        }
        return result
    }
}

#endif
