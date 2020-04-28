//
//  UISearchBar_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

// MARK: - Properties
public extension UISearchBar {

    /// NCanUtils: Text field inside search bar (if applicable).
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    /// NCanUtils: Text with no spaces or new lines in beginning and end (if applicable).
    var trimmedText: String {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

}

// MARK: - Methods
public extension UISearchBar {

    /// NCanUtils: Clear text.
    func clear() {
        text = ""
    }

    func setTextBoxHeight(_ height: CGFloat) {
        for subView in self.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds = textField.bounds
                    bounds.size.height = height
                    textField.bounds = bounds
                }
            }
        }
    }
    
    func setBoxStyle(textColor: UIColor = .black, placeholderColor: UIColor = .darkGray, textSize: CGFloat? = nil, backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.25)) {
        self.setImage(ImagesHelper.clear, for: .clear, state: .normal)
        self.setImage(ImagesHelper.search, for: .search, state: .normal)
        self.tintColor = textColor
        for subView in self.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.backgroundColor = backgroundColor
                    textField.textColor = textColor
                    textField.tintColor = textColor
                    textField.setPlaceHolderTextColor(placeholderColor)
                    if let size = textSize {
                        if let font = textField.font {
                            textField.font = font.withSize(size)
                        } else {
                            textField.font = UIFont.systemFont(ofSize: size)
                        }
                    }
                }
            }
        }
    }
}

#endif
