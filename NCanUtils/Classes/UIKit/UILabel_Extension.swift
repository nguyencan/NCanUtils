//
//  UILabel_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UILabel {

    /// NCanUtils: Initialize a UILabel with text
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// NCanUtils: Initialize a UILabel with a text and font style.
    ///
    /// - Parameters:
    ///   - text: the label's text.
    ///   - style: the text style of the label, used to determine which font should be used.
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }

    /// NCanUtils: Required height for a label
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }

    /// NCanUtils: Style for texts of label auch as: bold, color
    ///
    /// - Parameters:
    ///   - texts: Array String that will been applied style bold, color
    ///   - color: UIColor
    ///   - isBold: Bool
    ///   - multiple: CGFloat is line height multiple
    func styleForTexts(_ texts: [String], color: UIColor? = nil, isBold: Bool = false, multiple: CGFloat = 0) {
        guard let normalFont = self.font else {
            return
        }
        if let content = self.text {
            let attrStr = NSMutableAttributedString(string: content as String, attributes: [.font: normalFont])
            for text in texts {
                if content.contains(text) {
                    let ranges = attrStr.string.rangesOfExactString(findStr: text)
                    for range in ranges {
                        if let color = color {
                            attrStr.addAttribute(.foregroundColor, value: color, range: range)
                        }
                        if isBold {
                            attrStr.addAttribute(.font, value: normalFont.toBold(), range: range)
                        }
                    }
                }
            }
            let style = NSMutableParagraphStyle()
            style.alignment = textAlignment
            style.lineBreakMode = lineBreakMode
            if multiple > 0 {
                style.lineHeightMultiple = multiple
            }
            let range = NSRange(location: 0, length: attrStr.length)
            attrStr.addAttribute(.paragraphStyle, value: style, range: range)
            
            self.attributedText = attrStr
        }
    }
    
    /// NCanUtils: Set line height multiple for label
    ///
    /// - Parameter multiple: CGFloat
    func setLineHeightMultiple(multiple: CGFloat = 1.2) {
        // Check if there's any text
        guard let textString = text else { return }

        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingTail
        style.lineHeightMultiple = multiple

        let attrStr = NSMutableAttributedString(string: textString)
        let range = NSRange(location: 0, length: attrStr.length)
        attrStr.addAttribute(.paragraphStyle, value: style, range: range)
        
        self.attributedText = attrStr
    }
}

#endif
