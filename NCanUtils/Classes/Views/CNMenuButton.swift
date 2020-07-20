//
//  CNMenuButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/20/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNMenuButton: DesignableControl {

    @IBInspectable public var title: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var titleColor: UIColor = CNManager.shared.style.menu.titleColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var titleSize: CGFloat = CNManager.shared.style.menu.titleSize {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var titleLines: CGFloat = CNManager.shared.style.menu.lines {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var titleTopSpace: CGFloat = CNManager.shared.style.menu.titleTopSpace {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var titleLeftSpace: CGFloat = CNManager.shared.style.menu.titleLeftSpace {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var icon: UIImage? = nil {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var padding: CGFloat = CNManager.shared.style.menu.padding {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = CNManager.shared.style.menu.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsDisplay()
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialValues()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialValues()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        drawValues(rect: rect)
    }
    
    private func initialValues() {
        layer.cornerRadius = cornerRadius
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
        var maxY = rect.height - padding
        drawTitle(rect: rect, alpha: alpha, maxY: &maxY)
        drawImage(rect: rect, alpha: alpha, maxY: maxY)
        
        UIGraphicsPopContext()
    }
    
    private func drawTitle(rect: CGRect, alpha: CGFloat, maxY: inout CGFloat) {
        if title.isEmpty {
            return
        }
        let font = UIFont.systemFont(ofSize: titleSize, weight: CNManager.shared.style.menu.fontWeight)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        paragraph.paragraphSpacingBefore = 0
        paragraph.paragraphSpacing = 0
        paragraph.lineSpacing = 0
        
        let text = NSAttributedString(string: NSLocalizedString(title, comment: ""), attributes: [
            .font: font,
            .foregroundColor: titleColor.alpha(alpha),
            .paragraphStyle: paragraph
        ])
        let textSize = text.size()
        let textHeight: CGFloat
        if text.string.contains("\n") {
            textHeight = ceil(textSize.height)
        } else {
            textHeight = ceil(textSize.height*titleLines)
        }
        let textY: CGFloat
        if icon == nil {
            textY = floor((rect.height - textHeight)/2)
        } else {
            textY = floor(maxY - textHeight)
        }
        let textRect: CGRect = CGRect(
            x: titleLeftSpace,
            y: textY,
            width: ceil(rect.width - 2*titleLeftSpace),
            height: textHeight)
        let options: NSStringDrawingOptions
        if icon == nil {
            options = [.usesLineFragmentOrigin]
        } else {
            options = [.usesLineFragmentOrigin, .truncatesLastVisibleLine]
        }
        text.draw(with: textRect, options: options, context: nil)
        // Update preference parameter
        maxY = textY - titleTopSpace
    }
    
    private func drawImage(rect: CGRect, alpha: CGFloat, maxY: CGFloat) {
        guard let image = icon, rect.width > 0, rect.height > 0 else { return }
        let maxRect: CGRect = CGRect(
            x: padding,
            y: padding,
            width: ceil(rect.width - 2*padding),
            height: ceil(maxY - padding))
        let imageRect = calcImageRect(in: maxRect, imageSize: image.size)

        image.draw(in: imageRect, blendMode: .normal, alpha: alpha)
    }
    
    private func calcImageRect(in rect: CGRect, imageSize: CGSize) -> CGRect {
        let resultSize: CGSize
        if imageSize.width > rect.width || imageSize.height > rect.height {
            let widthRadio: CGFloat = imageSize.width/rect.width
            let heightRadio: CGFloat = imageSize.height/rect.height
            let raido: CGFloat = (widthRadio > heightRadio) ? widthRadio : heightRadio
            resultSize = CGSize(width: ceil(imageSize.width/raido), height: ceil(imageSize.height/raido))
        } else {
            resultSize = imageSize
        }
        let resultPoint = CGPoint(
            x: floor(rect.origin.x + (rect.width - resultSize.width)/2),
            y: floor(rect.origin.y + (rect.height - resultSize.height)/2))
        
        return CGRect(origin: resultPoint, size: resultSize)
    }
}

#endif
