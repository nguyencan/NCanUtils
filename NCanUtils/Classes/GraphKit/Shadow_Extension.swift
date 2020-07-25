//
//  Shadow_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/13/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - UIControl
extension UIControl {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

// MARK: - UILabel
extension UILabel {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

// MARK: - UIImageView
extension UIImageView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

#endif
