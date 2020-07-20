//
//  CNGradientButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/8/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
open class CNGradientButton: DesignableButton {

    @IBInspectable public var startColor: UIColor? = nil {
        didSet {
            refreshBackground()
        }
    }
    
    @IBInspectable public var endColor: UIColor? = nil {
        didSet {
            refreshBackground()
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
        setTitleColor(.white, for: .normal)
        cornerRadius = CNManager.shared.style.cornerRadius
        refreshBackground()
    }
    
    private func refreshBackground() {
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
        background.colors = colors
    }
}

#endif
