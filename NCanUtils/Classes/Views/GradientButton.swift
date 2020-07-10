//
//  GradientButton.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/8/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
public class GradientButton: DesignableButton {

    @IBInspectable var startColor: UIColor = .black {
        didSet {
            refreshBackground()
        }
    }
    
    @IBInspectable var endColor: UIColor = .black {
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
        cornerRadius = 5.0
        refreshBackground()
    }
    
    private func refreshBackground() {
        let colors: [UIColor]
        if startColor != endColor {
            colors = [startColor, endColor]
        } else {
            colors = [startColor]
        }
        corners.radius = cornerRadius
        background.colors = colors
    }
}

#endif
