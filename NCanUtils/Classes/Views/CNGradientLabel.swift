//
//  CNGradientLabel.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/17/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

@IBDesignable
open class CNGradientLabel: DesignableLabel {
    
    @IBInspectable public var startColor: UIColor? = nil {
        didSet {
            refreshValues()
        }
    }
    
    @IBInspectable public var endColor: UIColor? = nil {
        didSet {
            refreshValues()
        }
    }
    
    @IBInspectable public var isBorder: Bool = false {
        didSet {
            refreshValues()
        }
    }
    
    @IBInspectable public var isDashed: Bool = true {
        didSet {
            refreshValues()
        }
    }
    
    @IBInspectable public var effectTextColor: Bool = false {
        didSet {
            refreshValues()
        }
    }
    
    @IBInspectable public var padding: CGFloat = 0 {
        didSet {
            refreshValues()
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
    
    private func initialValues() {
        corners.corners = .allCorners
        corners.radius = CNManager.shared.style.cornerRadius
        refreshValues()
    }
    
    private func refreshValues() {
        var colors: [UIColor] = []
        if let color = startColor {
            colors.append(color)
        }
        if let color = endColor {
            colors.append(color)
        }
        let style = CNManager.shared.style
        if colors.isEmpty {
            colors = [style.gradientStartColor, style.gradientEndColor]
        }
        if effectTextColor {
            textColors.colors = colors
        }
        border.colors = colors
        if isBorder {
            border.width = style.borderWidth
        } else {
            border.width = 0
        }
        if isDashed {
            border.length = style.borderLength
            border.space = style.borderSpace
        } else {
            border.length = 0
            border.space = 0
        }
        textInsets = EdgeInsets(inset: padding)
    }
}

#endif
