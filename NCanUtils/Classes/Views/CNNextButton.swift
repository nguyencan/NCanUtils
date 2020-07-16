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
    
    @IBInspectable public var title: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var titleColor: UIColor = CNManager.shared.style.button.titleColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var titleSize: CGFloat = CNManager.shared.style.button.titleSize {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var subtitle: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var subtitleColor: UIColor = CNManager.shared.style.button.subtitleColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var subtitleSize: CGFloat = CNManager.shared.style.button.subtitleSize {
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
            maxX = x - 5
        }
        // Draw left icon
        if let image = icon {
            let x: CGFloat = minX
            let y: CGFloat = (rect.height - image.size.height)/2
            
            image.draw(at: CGPoint(x: x, y: y), blendMode: .normal, alpha: alpha)
            minX = x + image.size.width + horizontalSpace
        }
        
        // Draw titles
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byTruncatingTail
        paragraph.lineHeightMultiple = 1
        paragraph.alignment = .left
        paragraph.lineSpacing = 0
        
        var texts: [String] = []
        if !title.isEmpty {
            texts.append(NSLocalizedString(title, comment: ""))
        }
        if !subtitle.isEmpty {
            texts.append(NSLocalizedString(subtitle, comment: ""))
        }
        if texts.count == 1 {
            // Draw title with one line
            let text = NSAttributedString(string: texts.first!, attributes: [
                .font: UIFont.systemFont(ofSize: titleSize),
                .foregroundColor: titleColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            let textSize = text.size()
            let textRect: CGRect = CGRect(
                x: minX,
                y: (rect.height - textSize.height)/2,
                width: maxX - minX,
                height: textSize.height)
            
            text.draw(in: textRect)
        } else if texts.count == 2 {
            // Draw title with two line
            let titleAttributtedString = NSAttributedString(string: texts.first!, attributes: [
                .font: UIFont.systemFont(ofSize: titleSize),
                .foregroundColor: titleColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            let subtitleAttributedString = NSAttributedString(string: texts.last!, attributes: [
                .font: UIFont.systemFont(ofSize: subtitleSize),
                .foregroundColor: subtitleColor.alpha(alpha),
                .paragraphStyle: paragraph
            ])
            
            let titleTextSize = titleAttributtedString.size()
            let subtitleTextSize = subtitleAttributedString.size()
            
            let totalHeight: CGFloat = titleTextSize.height + subtitleTextSize.height + lineSpace
            let titleY: CGFloat = (rect.height - totalHeight)/2
            let subtitleY: CGFloat = titleY + titleTextSize.height + lineSpace
            
            let titleTextRect: CGRect = CGRect(
                x: minX,
                y: titleY,
                width: maxX - minX,
                height: titleTextSize.height)
            titleAttributtedString.draw(in: titleTextRect)
            
            let subtitleTextRect: CGRect = CGRect(
                x: minX,
                y: subtitleY,
                width: maxX - minX,
                height: subtitleTextSize.height)
            subtitleAttributedString.draw(in: subtitleTextRect)
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
}

#endif
