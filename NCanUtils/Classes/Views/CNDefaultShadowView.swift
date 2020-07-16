//
//  CNDefaultShadowView.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/16/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNDefaultShadowView: DesignableView {

    @IBInspectable var viewPosition: Int = Position.unique.rawValue {
        didSet {
            position = Position(rawValue: viewPosition)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadow: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var rounded: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var position: Position = .unique

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Draw rounded corners
        if rounded {
            addDefaultRounded(position)
        } else {
            removeRounded()
        }
        // Draw shadow
        if shadow {
            addDefaultShadow(position)
        } else {
            removeShadow()
        }
    }
}

#endif
