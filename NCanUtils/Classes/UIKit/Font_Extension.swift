//
//  Font_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/26/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public extension UIFont {
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }
    
    func toBold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func toItalic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

public extension UIFont {
    
    static func load(_ fontName: String, fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: fontName, size: fontSize) {
            return font
        }
        return UIFont.systemFont(ofSize: fontSize)
    }
}

#endif
