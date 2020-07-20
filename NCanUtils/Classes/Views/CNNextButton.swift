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
    
    @IBInspectable public var horizontalSpace: CGFloat = CNManager.shared.style.button.horizontalSpace {
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

    @IBInspectable public var isValueView: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var isSkipArrowSpace: Bool = false {
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
    
    private let strictSpace: CGFloat = 5
    
    open override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        drawValues(rect: rect)
    }
    
    private func drawValues(rect: CGRect) {
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
        var maxX: CGFloat = rect.width - horizontalSpace
        var minX: CGFloat = horizontalSpace
        
        // Draw arrow icon
        if arrow {
            let image = ImagesHelper.arrow
            let x: CGFloat = maxX - image.size.width
            let y: CGFloat = (rect.height - image.size.height)/2
            
            image.draw(at: CGPoint(x: x, y: y), blendMode: .normal, alpha: alpha)
            maxX = x
            if isValueView {
                if ceil(horizontalSpace/2) > 8 {
                    maxX -= ceil(horizontalSpace/2)
                } else {
                    maxX -= 8
                }
            } else {
                maxX -= strictSpace
            }
        } else {
            if isValueView, !isSkipArrowSpace {
                let image = ImagesHelper.arrow
                let x: CGFloat = maxX - image.size.width
                maxX = x
                if ceil(horizontalSpace/2) > 8 {
                    maxX -= ceil(horizontalSpace/2)
                } else {
                    maxX -= 8
                }
            }
        }
        // Draw left icon
        if let image = icon {
            let x: CGFloat = minX
            let y: CGFloat = (rect.height - image.size.height)/2
            
            image.draw(at: CGPoint(x: x, y: y), blendMode: .normal, alpha: alpha)
            minX = x + image.size.width + horizontalSpace
        }
        
        if isValueView {
            drawValueView(rect: rect, startX: minX, endX: maxX, alpha: alpha)
        } else {
            drawTitleViews(rect: rect, startX: minX, endX: maxX, alpha: alpha)
        }
        
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
    
    private func drawValueView(rect: CGRect, startX: CGFloat, endX: CGFloat, alpha: CGFloat) {
        var currentX: CGFloat = startX
        if !secondaryText.isEmpty {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byTruncatingTail
            paragraph.lineHeightMultiple = 1
            paragraph.alignment = .left
            paragraph.lineSpacing = 0
            // Draw label view
            let text = NSAttributedString(string: NSLocalizedString(secondaryText, comment: ""), attributes: [
                .font: UIFont.systemFont(ofSize: primarySize),
                .foregroundColor: secondaryColor.alpha(alpha),
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
        if !primaryText.isEmpty {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byTruncatingTail
            paragraph.lineHeightMultiple = 1
            paragraph.alignment = .right
            paragraph.lineSpacing = 0
            // Draw label view
            let text = NSAttributedString(string: NSLocalizedString(primaryText, comment: ""), attributes: [
                .font: UIFont.systemFont(ofSize: primarySize),
                .foregroundColor: primaryColor.alpha(alpha),
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
