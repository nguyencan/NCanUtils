//
//  CNCircleButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/25/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNCircleButton: DesignableControl {

    @IBInspectable public var icon: UIImage? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var iconColor: UIColor? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var image: UIImage? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var overlay: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var overlayColor: UIColor = CNManager.shared.style.circle.overlayColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var bordered: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = CNManager.shared.style.circle.borderColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = CNManager.shared.style.circle.borderWidth {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var padding: CGFloat = CNManager.shared.style.circle.padding {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadow: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = size.width
        
        return size
    }
    
    open override func draw(_ rect: CGRect) {
        corners = CornerStyle(radius: rect.width/2)
        if bordered {
            border.colors = [borderColor]
            border.width = borderWidth
        } else {
            border.colors = []
            border.width = 0
        }
        super.draw(rect)
        // Draw shadow
        if shadow {
            addShadow()
        } else {
            removeShadow()
        }
    }
    
    public override func subclassDraw(_ rect: CGRect) {
        // Draw subviews
        drawSubviews(rect: rect)
    }
}

// MARK: - Draw custom view
extension CNCircleButton {
    
    private func drawSubviews(rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.saveGState()
        
        UIGraphicsPushContext(context)
        
        let alpha: CGFloat
        if isHighlighted && isEnabled {
            alpha = CNManager.shared.style.button.highlightedAlpha
        } else {
            alpha = 1
        }
        drawImage(rect: rect)
        drawOverlay(rect)
        drawIcon(rect: rect, alpha: alpha)
        
        UIGraphicsPopContext()
    }
    
    private func drawImage(rect: CGRect) {
        guard let image = image else { return }
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        var boundary = rect
        if bordered, borderWidth > 0 {
            boundary = boundary.addMargin(borderWidth)
        }
        let rounded = UIBezierPath(roundedRect: boundary, byRoundingCorners: corners.corners, cornerRadii: CGSize(width: corners.radius, height: corners.radius))
        rounded.addClip()
        image.draw(in: boundary.getAspectFillRect(shape: image.size))
        
        context?.restoreGState()
    }
    
    private func drawOverlay(_ rect: CGRect) {
        guard overlay else { return }
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        overlayColor.set()
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners.corners, cornerRadii: CGSize(width: corners.radius, height: corners.radius))
        path.fill()
        
        context?.restoreGState()
    }

    private func drawIcon(rect: CGRect, alpha: CGFloat) {
        guard var image = icon, rect.width > 0, rect.height > 0 else { return }
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        var space: CGFloat = padding
        if bordered, borderWidth > 0 {
            space += borderWidth
        }
        let maxRect: CGRect = CGRect(
            x: space,
            y: space,
            width: ceil(rect.width - 2*space),
            height: ceil(rect.height - 2*space))
        let imageRect = maxRect.getDrawRect(shape: image.size)
        if let color = iconColor {
            image = image.mask(color: color) ?? image
        }
        image.draw(in: imageRect, blendMode: .normal, alpha: alpha)
        
        context?.restoreGState()
    }
}

#endif
