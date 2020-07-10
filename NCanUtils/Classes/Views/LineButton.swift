//
//  LineButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/8/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
public class LineButton: DesignableButton {
    
    @IBInspectable var startColor: UIColor = .black {
        didSet {
            refreshBorder()
        }
    }
    
    @IBInspectable var endColor: UIColor = .black {
        didSet {
            refreshBorder()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            refreshBorder()
        }
    }

    @IBInspectable var effectTitleColor: Bool = false {
        didSet {
            refreshBorder()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialValues()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Set title color
        if effectTitleColor, let color = generateLinearGradientColor(colors: border.colors, direction: .vertical, rect: bounds) {
            setTitleColor(color, for: .normal)
        }
    }
    
    private func initialValues() {
        cornerRadius = 5.0
        refreshBorder()
    }
    
    private func refreshBorder() {
        let colors: [UIColor]
        if startColor != endColor {
            colors = [startColor, endColor]
        } else {
            colors = [startColor]
        }
        corners.radius = cornerRadius
        border.colors = colors
        border.width = borderWidth
    }

}

#endif
