//
//  CNRoundedShadowView.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/15/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNRoundedShadowView: DesignableView {
    
    @IBInspectable public var cornerRadius: CGFloat = CNManager.shared.style.cornerRadius {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = CNManager.shared.style.shadowColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var shadowAlpha: Float = CNManager.shared.style.shadowAlpha {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var shadowBlur: CGFloat = CNManager.shared.style.shadowBlur {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CNManager.shared.style.shadowOffset {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var shadowSpread: CGFloat = CNManager.shared.style.shadowSpread {
        didSet {
            setNeedsDisplay()
        }
    }

    open override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        super.draw(rect)

        addSketchShadow(color: shadowColor, alpha: shadowAlpha, x: shadowOffset.width, y: shadowOffset.height, blur: shadowBlur, spread: shadowSpread)
    }
}

#endif
