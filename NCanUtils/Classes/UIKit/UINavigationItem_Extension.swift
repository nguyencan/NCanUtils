//
//  UINavigationItem_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UINavigationItem {
    
    enum Side {
        case left
        case right
    }
    
    /// NCanUtils: Replace title label with an image in navigation item.
    ///
    /// - Parameter image: UIImage to replace title with.
    func showTitleBar(with image: UIImage) {
        let logoImageView = UIImageView(frame: CGRect(width: 100, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = image
        titleView = logoImageView
    }
    
    func showLeftTitle(_ image: UIImage?, title: String, notiId: String = "", completion: (() -> Void)? = nil) {
        let view = CNLeftSideTitleView()
        view.set(image, title: title)
        view.getAction().actionHandler(controlEvents: .touchUpInside) {
            if let completion = completion {
                completion()
            } else if !notiId.isEmpty {
                let name = Notification.Name(notiId)
                NotificationCenter.default.post(name: name, object: nil)
            }
        }
        self.titleView = view
    }
    
    /// NCanUtils: Replace title label with two line (title & subtitle) in navigation item.
    ///
    /// - Parameters:
    ///   - title: String to first line
    ///   - titleColor: UIColor to tex color of first line
    ///   - titleSize: CGFloat to font size of first line
    ///   - subtitle: String to second line
    ///   - subtitleColor: UIColor to tex color of second line
    ///   - subtitleSize: CGFloat to font size of second line
    ///   - alignment: NSTextAlignment to title paragraph
    ///   - multiple: CGFloat to line height multiple of title paragraph
    ///   - notiId: String to post local notification
    ///   - completion: Closure to send action on title bar
    func showTwoLineTitle(title: String
        , titleColor: UIColor = .black
        , titleSize: CGFloat = 14
        , subtitle: String
        , subtitleColor: UIColor = .lightGray
        , subtitleSize: CGFloat = 12
        , alignment: NSTextAlignment = .center
        , multiple: CGFloat = 1.2
        , notiId: String = ""
        , completion: (() -> Void)? = nil) {
        
        let view = CNLeftSideTitleView()
        view.set(title
            , titleColor: titleColor
            , titleSize: titleSize
            , subtitle: subtitle
            , subtitleColor: subtitleColor
            , subtitleSize: subtitleSize
            , alignment: alignment
            , multiple: multiple)
        view.getAction().disableHighlighted = (completion == nil && notiId.isEmpty)
        view.getAction().actionHandler(controlEvents: .touchUpInside) {
            if let completion = completion {
                completion()
            } else if !notiId.isEmpty {
                let name = Notification.Name(notiId)
                NotificationCenter.default.post(name: name, object: nil)
            }
        }
        self.titleView = view
    }
    
    /// NCanUtils: Add space at side to Navigation bar with button's width
    /// 
    /// - Parameter side: UINavigationItem.Side
    func addBlankButton(side: Side) {
        let button = UIBarButtonItem(image: ImagesHelper.blank, style: .plain, target: self, action: nil)
        if side == .left {
            self.setLeftBarButtonItems([button], animated: true)
        } else {
            self.setRightBarButtonItems([button], animated: true)
        }
    }
    
    func showSearchBarTitle(_ title: String
        , textColor: UIColor = .black
        , placeholderColor: UIColor = .darkGray
        , textSize: CGFloat = 16
        , boxColor: UIColor = .lightGray
        , cancelTitle: String = "Cancel"
        , cancelColor: UIColor = .black
        , delegate: UISearchBarDelegate? = nil
        , completion: (() -> Void)? = nil) {
        
        let searchBar = UISearchBar(frame: CGRect(width: 100, height: 52))
        searchBar.placeholder = title
        searchBar.setBoxStyle(textColor: textColor, placeholderColor: placeholderColor, textSize: textSize, backgroundColor: boxColor)
        searchBar.showsCancelButton = false
        searchBar.delegate = delegate
        searchBar.setTextBoxHeight(36)

        let button = CustomButton(frame: CGRect(width: 30, height: 30))
        button.contentEdgeInsets = UIEdgeInsets(left: 8, right: 5)
        button.setTitle(cancelTitle, for: .normal)
        button.setFontSize(textSize)
        button.setTitleColor(cancelColor, for: .normal)
        button.actionHandler(controlEvents: .touchUpInside) {
            searchBar.resignFirstResponder()
            completion?()
        }
        button.sizeToFit()
        
        self.titleView = searchBar
        self.setRightBarButtonItems([UIBarButtonItem(customView: button)], animated: true)
    }
}

#endif
