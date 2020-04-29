//
//  UIView_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public extension UIView {
    
    func hide() {
        alpha = 0
        if let constraint = getHeightConstraint() {
            constraint.constant = 0
        }
    }
    
    func show(defaultHeight: CGFloat) {
        alpha = 1
        if let constraint = getHeightConstraint() {
            constraint.constant = defaultHeight
        }
    }
    
    func getHeightConstraint() -> NSLayoutConstraint? {
        return self.constraints.filter { (constraint) -> Bool in
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .height, constraint.secondItem == nil {
                return true
            }
            return false
            }.first
    }
}

#endif
