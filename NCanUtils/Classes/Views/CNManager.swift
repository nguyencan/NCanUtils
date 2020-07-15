//
//  CNManager.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/14/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public class CNViewStyle {
    
    public var highlightedAlpha: CGFloat = 0.5
    
    public var cornerRadius: CGFloat = 5
    
    public var borderWidth: CGFloat = 1
    public var borderLength: CGFloat = 4
    public var borderSpace: CGFloat = 2
    
    public var shadowColor: UIColor = UIColor(hex: 0x8993A4)
    public var shadowAlpha: Float = 0.16
    public var shadowBlur: CGFloat = 16
    public var shadowOffset: CGSize = CGSize(width: 0, height: 4)
    public var shadowSpread: CGFloat = 0
    
    public var gradientStartColor: UIColor = UIColor(hex: 0x43E695)
    public var gradientEndColor: UIColor = UIColor(hex: 0x3BB2B8)
    
    public var progressStartColor: UIColor = UIColor(hex: 0x43E695)
    public var progressEndColor: UIColor = UIColor(hex: 0x3BB2B8)
    public var progressBgStartColor: UIColor = .clear
    public var progressBgEndColor: UIColor = .clear
    
    public var rippleEffect: Bool = false
    public var rippleColor: UIColor = UIColor(hex: 0x55C2C2)
    
    public var button = ButtonStyle()
    
}

public class ButtonStyle {
    
    public var titleColor: UIColor = UIColor(hex: 0x172B4D)
    public var titleSize: CGFloat = 16
    
    public var subtitleColor: UIColor = UIColor(hex: 0x8993A4)
    public var subtitleSize: CGFloat = 12
    
    public var verticalPadding: CGFloat = 16
    public var lineSpace: CGFloat = 2
    
    public var dividerColor: UIColor = UIColor(hex: 0xF4F5F7)
}

public class CNManager {
    
    /**
     The `CNManager` singleton instance.
     */
    public static let shared = CNManager()
    
    /**
     The shared view style.
     */
    public var style = CNViewStyle()
}

#endif
