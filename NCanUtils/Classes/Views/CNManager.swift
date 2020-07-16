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
    
    public var button = ButtonStyle()
    public var progress = ProgressStyle()
}

public class ProgressStyle {
    
    public var startColor: UIColor = UIColor(hex: 0x43E695)
    public var endColor: UIColor = UIColor(hex: 0x3BB2B8)
    public var bgStartColor: UIColor = .clear
    public var bgEndColor: UIColor = .clear
}

public class ButtonStyle {
    
    public var highlightedAlpha: CGFloat = 0.5
    
    public var rippleEffect: Bool = false
    public var rippleColor: UIColor = UIColor(hex: 0x55C2C2)
    
    public var titleColor: UIColor = UIColor(hex: 0x172B4D)
    public var titleSize: CGFloat = 16
    
    public var subtitleColor: UIColor = UIColor(hex: 0x8993A4)
    public var subtitleSize: CGFloat = 12
    
    public var horizontalSpace: CGFloat = 16
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
