//
//  CustomXibViewUtility.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/26/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIView {
    
    private struct AssociatedKeys {
        static var contentView: String = "NCanUtils+CustomXibView:contentView"
    }
    
    private var contentView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.contentView) as? UIView ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.contentView, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// NCanUtils: Initilize for custom view with xib file.
    /// 
    /// - Call in init(frame) & init(decoder) of custom view class
    ///
    public func initilizeForCustomXibView() {
        contentView = loadViewFromNib()
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView!.translatesAutoresizingMaskIntoConstraints = true
        contentView!.backgroundColor = .clear
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
        
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}

#endif
