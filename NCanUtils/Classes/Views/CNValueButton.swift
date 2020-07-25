//
//  CNValueButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/24/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNValueButton: DesignableControl {
    
    @IBInspectable public var title: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var titleColor: UIColor = CNManager.shared.style.value.titleColor {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var value: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var valueColor: UIColor = CNManager.shared.style.value.valueColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var textSize: CGFloat = CNManager.shared.style.value.textSize {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var lineSpace: CGFloat = CNManager.shared.style.button.lineSpace {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var padding: CGFloat = CNManager.shared.style.button.padding {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var icon: UIImage? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var arrow: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var skipArrowSpace: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var divider: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var dividerColor: UIColor = CNManager.shared.style.button.dividerColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let strictSpace: CGFloat = 5
    
    open override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func draw(_ rect: CGRect) {
        if rounded {
            corners.radius = CNManager.shared.style.button.cornerRadius
        } else {
            corners.radius = 0
        }
        super.draw(rect)
        // Draw subviews
        drawSubviews(rect: rect)
        // Draw shadow
        if shadow {
            addShadow()
        } else {
            removeShadow()
        }
    }
}

// MARK: - Draw custom view
extension CNValueButton {
    
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
        var maxX: CGFloat = rect.width - padding
        var minX: CGFloat = padding
        
        // Draw arrow icon
        if arrow {
            let image = ImagesHelper.arrow
            let x: CGFloat = maxX - image.size.width
            let y: CGFloat = (rect.height - image.size.height)/2
            
            image.draw(at: CGPoint(x: x, y: y), blendMode: .normal, alpha: alpha)
            maxX = x
            if ceil(padding/2) > 8 {
                maxX -= ceil(padding/2)
            } else {
                maxX -= 8
            }
        } else if !skipArrowSpace {
            let image = ImagesHelper.arrow
            let x: CGFloat = maxX - image.size.width
            maxX = x
            if ceil(padding/2) > 8 {
                maxX -= ceil(padding/2)
            } else {
                maxX -= 8
            }
        }
        // Draw left icon
        if let image = icon {
            let x: CGFloat = minX
            let y: CGFloat = (rect.height - image.size.height)/2
            
            image.draw(at: CGPoint(x: x, y: y), blendMode: .normal, alpha: alpha)
            minX = x + image.size.width + padding
        }
        // Draw texts
        drawValueView(rect: rect, startX: minX, endX: maxX, alpha: alpha)
        // Draw bottom line
        if divider {
            let width = CNManager.shared.style.borderWidth
            context.setStrokeColor(dividerColor.alpha(alpha).cgColor)
            context.setLineWidth(width)
            context.move(to: CGPoint(x: 0, y: bounds.height - width))
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            context.strokePath()
        }
        
        UIGraphicsPopContext()
    }
    
    private func drawValueView(rect: CGRect, startX: CGFloat, endX: CGFloat, alpha: CGFloat) {
        var currentX: CGFloat = startX
        if !title.isEmpty {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byTruncatingTail
            paragraph.lineHeightMultiple = 1
            paragraph.alignment = .left
            paragraph.lineSpacing = 0
            // Draw label view
            let text = NSAttributedString(string: NSLocalizedString(title, comment: ""), attributes: [
                .font: UIFont.systemFont(ofSize: textSize),
                .foregroundColor: titleColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            let textSize = text.size()
            let width: CGFloat
            if textSize.width > endX - currentX {
                width = endX - currentX
            } else {
                width = textSize.width
            }
            let textRect: CGRect = CGRect(
                x: currentX,
                y: (rect.height - textSize.height)/2,
                width: width,
                height: textSize.height)
            
            text.draw(in: textRect)
            
            currentX += width + strictSpace
        }
        if !value.isEmpty {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byTruncatingTail
            paragraph.lineHeightMultiple = 1
            paragraph.alignment = .right
            paragraph.lineSpacing = 0
            // Draw label view
            let text = NSAttributedString(string: NSLocalizedString(value, comment: ""), attributes: [
                .font: UIFont.systemFont(ofSize: textSize),
                .foregroundColor: valueColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            let textSize = text.size()
            let textRect: CGRect = CGRect(
                x: currentX,
                y: (rect.height - textSize.height)/2,
                width: endX - currentX,
                height: textSize.height)
            
            text.draw(in: textRect)
        }
    }
}

#endif
