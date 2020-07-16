//
//  CNProgressView.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/13/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

public extension ProgressView {
    
    enum Style: Int {
        case circle, point
    }
    
    static let circleDuration: TimeInterval = 1.0
    
    static func showCircleProgress(startColor: UIColor? = nil, endColor: UIColor? = nil, background: [UIColor] = []) {
        show(style: .circle, startColor: startColor, endColor: endColor, background: background)
    }
    
    static func showPointsProgress(startColor: UIColor? = nil, endColor: UIColor? = nil, background: [UIColor] = []) {
        show(style: .point, startColor: startColor, endColor: endColor, background: background)
    }
    
    static func show(style: ProgressView.Style = .circle, startColor: UIColor? = nil, endColor: UIColor? = nil, background: [UIColor] = []) {
        if let window: UIWindow = UIApplication.getWindow() {
            let view = ProgressView(frame: window.bounds)
            view.tag = ProgressView.name.hashValue
            view.style = style
            view.startColor = startColor
            view.endColor = endColor
            if !background.isEmpty {
                view._mBackgroundView.colors = background
            } else {
                let style = CNManager.shared.style.progress
                view._mBackgroundView.colors = [style.bgStartColor, style.bgEndColor]
            }
            view.layer.zPosition = 10000
            window.addSubview(view)
        }
    }
    
    static func dismiss() {
        if let window: UIWindow = UIApplication.getWindow() {
            let tag: Int = ProgressView.name.hashValue
            for view in window.subviews {
                if view.tag == tag {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

public class ProgressView: UIView {

    class var name: String {
        return "\(self)"
    }
    
    lazy internal var _mProgressCircleBar: CNProgressCircleView = {
        let view = CNProgressCircleView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoAnimation = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy internal var _mProgressPointsBar: CNProgressPointsView = {
        let view = CNProgressPointsView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.isAnimation = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy internal var _mBackgroundView: BackgroundView = {
        let view = BackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var style: Style = .circle {
        didSet {
            if style == .circle {
                _mProgressCircleBar.alpha = 1
                _mProgressPointsBar.alpha = 0
            } else {
                _mProgressCircleBar.alpha = 0
                _mProgressPointsBar.alpha = 1
            }
        }
    }
    
    var startColor: UIColor? = nil {
        didSet {
            _mProgressCircleBar.startColor = startColor
            _mProgressPointsBar.startColor = startColor
        }
    }
    
    var endColor: UIColor? = nil {
        didSet {
            _mProgressCircleBar.endColor = endColor
            _mProgressPointsBar.endColor = endColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilizeBackground()
        initilizeProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilizeBackground()
        initilizeProgress()
    }
    
    private func initilizeProgress() {
        // Add Circle view
        addSubview(_mProgressCircleBar)
        
        let height = NSLayoutConstraint(item: _mProgressCircleBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let width = NSLayoutConstraint(item: _mProgressCircleBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let centerX = NSLayoutConstraint(item: _mProgressCircleBar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: _mProgressCircleBar, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([height, width, centerX, centerY])
        
        // Add Points view
        addSubview(_mProgressPointsBar)
        
        let centerPX = NSLayoutConstraint(item: _mProgressPointsBar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerPY = NSLayoutConstraint(item: _mProgressPointsBar, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([centerPX, centerPY])
    }
    
    private func initilizeBackground() {
        addSubview(_mBackgroundView)
        
        let left = NSLayoutConstraint(item: _mBackgroundView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: _mBackgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: _mBackgroundView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: _mBackgroundView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([left, top, right, bottom])
        
        self.backgroundColor = .clear
    }
}

@IBDesignable
class BackgroundView: UIView {
    
    var colors: [UIColor] = [] {
        didSet {
            drawBackground()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawBackground()
    }
    
    private func drawBackground() {
        // Prepare background colors
        var result: [UIColor] = []
        for color in colors {
            if !result.contains(color) {
                result.append(color)
            }
        }
        if result.count > 1 {
            addGradientBackground(colors: result, direction: .horizontal, radius: 0)
        } else {
            removeGradientBackground()
            backgroundColor = (result.first ?? UIColor.black).alpha(0.16)
        }
    }
}

#endif
