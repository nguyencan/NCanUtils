//
//  CNLineButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/8/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNLineButton: DesignableButton {
    
    @IBInspectable public var startColor: UIColor? = nil {
        didSet {
            refreshBorder()
        }
    }
    
    @IBInspectable public var endColor: UIColor? = nil {
        didSet {
            refreshBorder()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = CNManager.shared.style.borderWidth {
        didSet {
            refreshBorder()
        }
    }

    @IBInspectable public var effectTitleColor: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var defaultTitleColor: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialValues()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialValues()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Set title color
        if effectTitleColor, let color = generateLinearGradientColor(colors: border.colors, direction: .vertical, rect: bounds) {
            setTitleColor(color, for: .normal)
        } else if defaultTitleColor {
            setTitleColor(CNManager.shared.style.button.primaryColor, for: .normal)
        }
    }
    
    private func initialValues() {
        cornerRadius = CNManager.shared.style.cornerRadius
        refreshBorder()
    }
    
    private func refreshBorder() {
        var colors: [UIColor] = []
        if let color = startColor {
            colors.append(color)
        }
        if let color = endColor {
            colors.append(color)
        }
        if colors.isEmpty {
            let style = CNManager.shared.style
            colors = [style.gradientStartColor, style.gradientEndColor]
        }
        corners.radius = cornerRadius
        border.colors = colors
        border.width = borderWidth
    }
}

#endif
