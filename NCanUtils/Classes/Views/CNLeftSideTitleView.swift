//
//  CNLeftSideTitleView.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

class CNLeftSideTitleView: UIView {
    
    lazy var button: CustomButton = {
        let button = CustomButton()
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(right: 6)
        button.titleEdgeInsets = UIEdgeInsets(left: 6)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initilize()
    }
    
    override var intrinsicContentSize: CGSize {
      return UIView.layoutFittingExpandedSize
    }
    
    private func initilize() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        ])
    }
    
    func set(_ image: UIImage?, title: String, color: UIColor = .black, size: CGFloat = 16) {
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(right: 6)
        button.titleEdgeInsets = UIEdgeInsets(left: 6)
        button.setImage(image, for: [])
        button.setTitle(title, for: [])
        button.setTitleColor(color, for: [])
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    func set(_ title: String
        , titleColor: UIColor = .black
        , titleSize: CGFloat = 14
        , subtitle: String
        , subtitleColor: UIColor = .lightGray
        , subtitleSize: CGFloat = 12
        , alignment: NSTextAlignment = .center
        , multiple: CGFloat = 1.2) {
        
        let titleAttr = NSMutableAttributedString(string: title, attributes: [
            .foregroundColor : titleColor,
            .font : UIFont.systemFont(ofSize: titleSize, weight: .medium)
        ])
        let subtitleAttr = NSAttributedString(string: subtitle, attributes: [
            .foregroundColor : subtitleColor,
            .font : UIFont.systemFont(ofSize: subtitleSize, weight: .regular)
        ])

        titleAttr.append(NSAttributedString(string: "\n"))
        titleAttr.append(subtitleAttr)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = alignment
        
        if multiple > 0 {
            paragraphStyle.lineHeightMultiple = multiple
        }
        titleAttr.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: titleAttr.length
        ))
        
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.lineBreakMode = .byTruncatingTail;
        button.titleLabel?.textAlignment = alignment
        if alignment == .left {
            button.contentHorizontalAlignment = .left
        } else if alignment == .right {
            button.contentHorizontalAlignment = .right
        } else {
            button.contentHorizontalAlignment = .center
        }
        button.imageEdgeInsets = .zero
        button.titleEdgeInsets = .zero
        button.setAttributedTitle(titleAttr, for: [])
    }
    
    func getAction() -> CustomButton {
        return button
    }
}

class CustomButton: UIButton {
    
    var disableHighlighted: Bool = true
    
    override var isHighlighted: Bool {
        didSet {
            if disableHighlighted {
                imageView?.alpha = 1.0
                titleLabel?.alpha = 1.0
            } else if isHighlighted {
                imageView?.alpha = 0.5
                titleLabel?.alpha = 0.5
            } else{
                imageView?.alpha = 1.0
                titleLabel?.alpha = 1.0
            }
        }
    }
}

#endif
