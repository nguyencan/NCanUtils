//
//  UITextField_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public enum KeyboardStyleMode : Int {

    
    case unspecified

    case light

    case dark
}

// MARK: - Enums
public extension UITextField {

    /// NCanUtils: UITextField text type.
    ///
    /// - emailAddress: UITextField is used to enter email addresses.
    /// - password: UITextField is used to enter passwords.
    /// - generic: UITextField is used to enter generic text.
    enum TextType {
        /// NCanUtils: UITextField is used to enter email addresses.
        case emailAddress

        /// NCanUtils: UITextField is used to enter passwords.
        case password

        /// NCanUtils: UITextField is used to enter generic text.
        case generic
    }

}

// MARK: - Properties
public extension UITextField {

    /// NCanUtils: Set textField for common text types.
    var textType: TextType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false

            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true

            case .generic:
                isSecureTextEntry = false
            }
        }
    }

    /// NCanUtils: Check if text field is empty.
    var isEmpty: Bool {
        return text?.isEmpty == true
    }

    /// NCanUtils: Return text with no spaces or new lines in beginning and end.
    var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var intValue: Int {
        if let text = self.text, let value = Int(text) {
            return value
        }
        return 0
    }
    
    var doubleValue: Double {
        if let text = self.text, let value = Double(text) {
            return value
        }
        return 0
    }
    
    var floatValue: Float {
        if let text = self.text, let value = Float(text) {
            return value
        }
        return 0
    }

    /// NCanUtils: Check if textFields text is a valid email format.
    ///
    ///        textField.text = "john@doe.com"
    ///        textField.hasValidEmail -> true
    ///
    ///        textField.text = "NCanUtils"
    ///        textField.hasValidEmail -> false
    ///
    var hasValidEmail: Bool {
        if let text = text, text.isValidMail {
            return true
        }
        return false
    }

    /// NCanUtils: Left view tint color.
    @IBInspectable var leftViewTintColor: UIColor? {
        get {
            guard let iconView = leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }

    /// NCanUtils: Right view tint color.
    @IBInspectable var rightViewTintColor: UIColor? {
        get {
            guard let iconView = rightView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = rightView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }

}

// MARK: - Methods
public extension UITextField {

    /// NCanUtils: Clear text.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    /// NCanUtils: Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }

    /// NCanUtils: Add padding to the left of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }

    /// NCanUtils: Add padding to the left of the textfield rect.
    ///
    /// - Parameters:
    ///   - image: left image
    ///   - padding: amount of padding between icon and the left of textfield
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        leftView = imageView
        leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        leftViewMode = .always
    }
    
    /// NCanUtils: Add picker to keyboard
    ///
    /// - Parameters:
    ///   - picker: picker view
    ///   - target: action target
    ///   - title: picker title
    ///   - doneTitle: title of done button
    ///   - done: action of done button
    ///   - cancelTitle: title of cancel button
    ///   - cancel: action of cancel button
    ///   - barBackground: background of title bar
    ///   - titleColor: text color of title
    ///   - buttonColor: text color of buttons
    ///   - style: style mode of keyboard
    func addToolBarPicker(_ picker: UIView
        , target: AnyObject?
        , title: String? = nil
        , doneTitle: String = "Done"
        , done: Selector
        , cancelTitle: String = "Cancel"
        , cancel: Selector
        , barBackground: UIColor = .lightGray
        , titleColor: UIColor = .blue
        , buttonColor: UIColor = .blue
        , style: KeyboardStyleMode = .unspecified) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.barTintColor = barBackground
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: doneTitle, style: .plain, target: target, action: done)
        doneButton.tintColor = buttonColor
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: cancelTitle, style: .plain, target: target, action: cancel)
        cancelButton.tintColor = buttonColor
        
        if let title = title, !title.isEmpty {
            let lastUpdateLabel = UILabel(frame: CGRect.zero)
            lastUpdateLabel.text = title
            lastUpdateLabel.textColor = titleColor
            lastUpdateLabel.font = UIFont.boldSystemFont(ofSize: 15)
            lastUpdateLabel.backgroundColor = .clear
            lastUpdateLabel.textAlignment = .center
            lastUpdateLabel.sizeToFit()
            
            let titleView = UIBarButtonItem(customView: lastUpdateLabel)
            toolBar.setItems([cancelButton, spaceButton, titleView, spaceButton, doneButton], animated: true)
        } else {
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        }
        toolBar.isUserInteractionEnabled = true
        
        if style == .light {
            picker.backgroundColor = .white
            self.keyboardAppearance = .light
        } else if style == .dark {
            picker.backgroundColor = .black
            self.keyboardAppearance = .dark
        } else {
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    picker.backgroundColor = .black
                    self.keyboardAppearance = .dark
                } else {
                    picker.backgroundColor = .white
                    self.keyboardAppearance = .light
                }
            } else {
                picker.backgroundColor = .white
                self.keyboardAppearance = .light
            }
        }
        self.inputView = picker
        self.inputAccessoryView = toolBar
    }
    
}

#endif
