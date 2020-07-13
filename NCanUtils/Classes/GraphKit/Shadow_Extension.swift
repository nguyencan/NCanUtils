//
//  Shadow_Extension.swift
//  NCanUtils
//
//  Created by SG on 7/13/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - UIScrollView
extension UIScrollView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

// MARK: - UIControl
extension UIControl {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

// MARK: - UIStackView
extension UIStackView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

// MARK: -UIPickerView
extension UIPickerView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Draw shadow
        layer.refreshShadowSpread()
    }
}

// MARK: - UISearchBar
extension UISearchBar {
    
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
