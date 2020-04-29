//
//  UITextView+HTMLString.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(Foundation) && canImport(UIKit)
import Foundation
import UIKit

public extension UITextView {
    
    private static let indicatorTag: Int = 101
    
    func setPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        self.layoutMargins = .zero
        self.textContainer.lineFragmentPadding = 0
        self.contentInset = .zero
    }
    
    func setHtmlText(_ string: String?) {
        showProgress()
        
        let color: UIColor = self.textColor ?? .black
        let mFont: UIFont = self.font ?? UIFont.systemFont(ofSize: 16)
        let width: CGFloat = self.contentSize.width - (self.textContainerInset.left + self.textContainerInset.right)
        
        if var attributed = string?.htmlAttributed(using: mFont, color: color) {
            attributed = attributed.attributedStringWithResizedImages(with: width)
            self.text = nil
            self.attributedText = attributed
            self.hideProgress()
        } else {
            self.attributedText = nil
            self.text = string
            self.hideProgress()
        }
    }
    
    private func showProgress() {
        var indicatorView: UIActivityIndicatorView
        if let view = viewWithTag(UITextView.indicatorTag) as? UIActivityIndicatorView {
            indicatorView = view
        } else {
            indicatorView = UIActivityIndicatorView(style: .large)
            self.addSubview(indicatorView)
        }
        indicatorView.tag = UITextView.indicatorTag
        indicatorView.center = CGPoint(x: self.center.x, y: self.center.y - indicatorView.bounds.size.height)
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
    
    private func hideProgress() {
        if let view = viewWithTag(UITextView.indicatorTag) as? UIActivityIndicatorView {
            view.stopAnimating()
        }
    }
}

extension UIImage {
    
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension String {
    
    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        if isEmpty {
            return nil
        }
        var text: String = self
        if text.contains("\n") {
            text = text.replacingOccurrences(of: "\n", with: "<br/>")
        }
        let htmlCSSString = "<style>html *{" +
            "color: #\(color.hexString) !important;" +
        "}</style> \(text)"
        
        guard let result = ((try? NSAttributedString(HTMLString: htmlCSSString, font: font)) as NSAttributedString??) else {
            return nil
        }
        return result
    }
    
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        let mFont: UIFont
        if let name = family, let font = UIFont(name: name, size: size) {
            mFont = font
        } else {
            mFont = UIFont.systemFont(ofSize: size)
        }
        return htmlAttributed(using: mFont, color: color)
    }
}

// MARK: - NSAttributedString

extension NSAttributedString {
    
    public convenience init?(HTMLString html: String, font: UIFont? = nil) throws {
        if html.isEmpty {
            throw NSError(domain: "Html String's Empty", code: 0, userInfo: nil)
        }
        guard let data = html.data(using: String.Encoding.utf8) else {
            throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
        }
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let font = font {
            guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
                throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
            }
            let baseDescriptor = font.fontDescriptor
            attr.enumerateAttribute(.font, in: NSRange(location: 0, length: attr.length), options: []) { (object, range, _) in
                guard let font = object as? UIFont else { return }
                // Instantiate a font with our base font's family, but with the current range's traits
                let traits = font.fontDescriptor.symbolicTraits
                guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
                let newFont = UIFont(descriptor: descriptor, size: baseDescriptor.pointSize)
                attr.removeAttribute(.font, range: range)
                attr.addAttribute(.font, value: newFont, range: range)
            }
            self.init(attributedString: attr)
        } else {
            try? self.init(data: data, options: options, documentAttributes: nil)
        }
    }
    
    func attributedStringWithResizedImages(with maxWidth: CGFloat) -> NSAttributedString {
        let text = NSMutableAttributedString(attributedString: self)
        text.enumerateAttribute(.attachment, in: NSMakeRange(0, text.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let attachement = value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                if image.size.width > maxWidth {
                    let newImage = image.resizeImage(scale: maxWidth/image.size.width)
                    let newAttribut = NSTextAttachment()
                    newAttribut.image = newImage
                    text.addAttribute(.attachment, value: newAttribut, range: range)
                }
            }
        })
        return text
    }
}

#endif
