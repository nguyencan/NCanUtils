//
//  CALayer_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/13/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension CALayer {
    
    private struct AssociatedKeys {
        static var shadowSpread: String = "NCanUtils+CALayer:shadowSpread"
    }
    
    var shadowBlur: CGFloat {
        get {
            return shadowRadius * 2.0
        }
        set {
            shadowRadius = newValue / 2.0
        }
    }
    
    var shadowSpread: CGFloat {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.shadowSpread) as? CGFloat ?? 0)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shadowSpread, newValue as CGFloat, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // Draw shadow
            refreshShadowSpread()
        }
    }
    
    func refreshShadowSpread() {
        if shadowSpread == 0 {
            shadowPath = nil
        } else {
            let dx = -shadowSpread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

#endif
