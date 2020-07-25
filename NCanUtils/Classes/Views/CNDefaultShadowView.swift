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

    @IBInspectable var viewPosition: Int = GridPosition.unique.rawValue {
        didSet {
            position = GridPosition(rawValue: viewPosition)
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
    
    public var position: GridPosition = .unique

    open override func draw(_ rect: CGRect) {
        // Draw rounded corners
        if rounded {
            let radius: CGFloat
            if corners.radius > 0 {
                radius = corners.radius
            } else {
                radius = CNManager.shared.style.cornerRadius
            }
            corners = position.toCorners(radius: radius)
        } else {
            corners.radius = 0
        }
        super.draw(rect)
        // Draw shadow
        if shadow {
            addDefaultShadow(position.toSide())
        } else {
            removeShadow()
        }
    }
}

#endif
