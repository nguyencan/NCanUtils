//
//  CNNextButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/15/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNNextButton: DesignableControl {
    
    @IBInspectable public var primaryText: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var primaryColor: UIColor = CNManager.shared.style.button.primaryColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var primarySize: CGFloat = CNManager.shared.style.button.primarySize {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var secondaryText: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var secondaryColor: UIColor = CNManager.shared.style.button.secondaryColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var secondarySize: CGFloat = CNManager.shared.style.button.secondarySize {
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
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var viewPosition: Int = GridPosition.unique.rawValue {
        didSet {
            position = GridPosition(rawValue: viewPosition)
            setNeedsDisplay()
        }
    }
    
    public var position: GridPosition = .unique
    
    private let strictSpace: CGFloat = 5
    
    open override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func draw(_ rect: CGRect) {
        if rounded {
            let radius: CGFloat
            if corners.radius > 0 {
                radius = corners.radius
            } else {
                radius = CNManager.shared.style.button.cornerRadius
            }
            corners = position.toCorners(radius: radius)
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
extension CNNextButton {
    
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
            maxX = x - strictSpace
        }
        // Draw left icon
        if let image = icon {
            let x: CGFloat = minX
            let y: CGFloat = (rect.height - image.size.height)/2
            
            image.draw(at: CGPoint(x: x, y: y), blendMode: .normal, alpha: alpha)
            minX = x + image.size.width + padding
        }
        // Draw titles
        drawTitleViews(rect: rect, startX: minX, endX: maxX, alpha: alpha)
        // Draw bottom lines
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
    
    private func drawTitleViews(rect: CGRect, startX: CGFloat, endX: CGFloat, alpha: CGFloat) {
        // Draw titles
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byTruncatingTail
        paragraph.lineHeightMultiple = 1
        paragraph.alignment = .left
        paragraph.lineSpacing = 0
        
        var texts: [String] = []
        if !primaryText.isEmpty {
            texts.append(NSLocalizedString(primaryText, comment: ""))
        }
        if !secondaryText.isEmpty {
            texts.append(NSLocalizedString(secondaryText, comment: ""))
        }
        if texts.count == 1 {
            // Draw title with one line
            let text = NSAttributedString(string: texts.first!, attributes: [
                .font: UIFont.systemFont(ofSize: primarySize),
                .foregroundColor: primaryColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            let textSize = text.size()
            let textRect: CGRect = CGRect(
                x: startX,
                y: (rect.height - textSize.height)/2,
                width: endX - startX,
                height: textSize.height)
            
            text.draw(in: textRect)
        } else if texts.count == 2 {
            // Draw title with two line
            let titleAttributtedString = NSAttributedString(string: texts.first!, attributes: [
                .font: UIFont.systemFont(ofSize: primarySize),
                .foregroundColor: primaryColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            let subtitleAttributedString = NSAttributedString(string: texts.last!, attributes: [
                .font: UIFont.systemFont(ofSize: secondarySize),
                .foregroundColor: secondaryColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            
            let titleTextSize = titleAttributtedString.size()
            let subtitleTextSize = subtitleAttributedString.size()
            
            let totalHeight: CGFloat = titleTextSize.height + subtitleTextSize.height + lineSpace
            let titleY: CGFloat = (rect.height - totalHeight)/2
            let subtitleY: CGFloat = titleY + titleTextSize.height + lineSpace
            
            let titleTextRect: CGRect = CGRect(
                x: startX,
                y: titleY,
                width: endX - startX,
                height: titleTextSize.height)
            titleAttributtedString.draw(in: titleTextRect)
            
            let subtitleTextRect: CGRect = CGRect(
                x: startX,
                y: subtitleY,
                width: endX - startX,
                height: subtitleTextSize.height)
            subtitleAttributedString.draw(in: subtitleTextRect)
        }
    }
}

#endif
