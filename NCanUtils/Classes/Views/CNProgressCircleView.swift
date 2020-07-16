//
//  CNProgressCircleView.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/13/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
public class CNProgressCircleView: UIView {
    
    private final let circleBackgroundName = "circleBackgroundName"
    private final let circleProgressName = "circleProgressName"
    
    @IBInspectable public var startColor: UIColor? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var endColor: UIColor? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var lineWidth: CGFloat = 4 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var autoAnimation: Bool = false {
        didSet {
            if autoAnimation {
                needsAnimationForAuto = true
            } else {
                needsAnimationForAuto = false
            }
            setNeedsDisplay()
        }
    }

    private var needsAnimationForAuto: Bool = false // The default is the same autoAnimation's default
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if needsAnimationForAuto {
            needsAnimationForAuto = false
            if !isAnimation() {
                startAnimation()
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let bgLayer = findLayer(with: circleBackgroundName) {
            bgLayer.frame = getCircleFrame()
        }
        if let cirLayer = findLayer(with: circleProgressName) {
            cirLayer.frame = getCircleFrame()
        }
    }
    
    public func startAnimation() {
        prepareForCircles()
        guard let progress = findLayer(with: circleProgressName) else {
            return
        }
        let group = CAAnimationGroup()
        group.repeatCount = Float.greatestFiniteMagnitude
        
        let animation1 = CABasicAnimation(keyPath: "strokeEnd")
        animation1.fromValue = 0
        animation1.toValue = 0.5
        animation1.duration = 0.5
        animation1.beginTime = 0
        animation1.isRemovedOnCompletion = true
        animation1.fillMode = .forwards
        
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.fromValue = 0.4
        animation2.toValue = 1.0
        animation2.duration = 0.5
        animation2.beginTime = 0.35
        animation2.isRemovedOnCompletion = true
        animation2.fillMode = .forwards
        
        let animation3 = CABasicAnimation(keyPath: "strokeStart")
        animation3.fromValue = 0
        animation3.toValue = 0.5
        animation3.duration = 0.5
        animation3.beginTime = 0.3
        animation3.isRemovedOnCompletion = true
        animation3.fillMode = .forwards
        
        let animation4 = CABasicAnimation(keyPath: "strokeStart")
        animation4.fromValue = 0.4
        animation4.toValue = 1.0
        animation4.duration = 0.4
        animation4.beginTime = 0.6
        animation4.isRemovedOnCompletion = true
        animation4.fillMode = .forwards
        
        group.animations = [animation1, animation2, animation3, animation4]
        group.beginTime = 0
        group.duration = 1
        
        progress.removeAllAnimations()
        progress.add(group, forKey: "progress")
    }
    
    public func stopAnimation() {
        if let bgLayer = findLayer(with: circleBackgroundName) {
            bgLayer.removeFromSuperlayer()
        }
        if let cirLayer = findLayer(with: circleProgressName) {
            cirLayer.removeFromSuperlayer()
        }
    }
    
    public func toggleAnimation() {
        if isAnimation() {
            stopAnimation()
        } else {
            startAnimation()
        }
    }
    
    public func isAnimation() -> Bool {
        if let progress = findLayer(with: circleProgressName), let keys = progress.animationKeys(), !keys.isEmpty {
            return true
        }
        return false
    }
    
    private func configureUI(){
        self.transform = self.transform.rotated(by: -CGFloat.pi/2)
    }
    
    private func prepareForCircles() {
        let mBackgroundLayer: CAShapeLayer
        if let bgLayer = findLayer(with: circleBackgroundName) as? CAShapeLayer {
            mBackgroundLayer = bgLayer
        } else {
            mBackgroundLayer = CAShapeLayer()
            mBackgroundLayer.name = circleBackgroundName
            layer.addSublayer(mBackgroundLayer)
        }
        let frame = getCircleFrame()
        let path = UIBezierPath(ovalIn: frame).cgPath
        mBackgroundLayer.frame = frame
        mBackgroundLayer.path = path
        mBackgroundLayer.strokeColor = UIColor.black.alpha(0.08).cgColor
        mBackgroundLayer.lineWidth = lineWidth
        mBackgroundLayer.fillColor = UIColor.clear.cgColor
        
        let mProgressLayer: CAShapeLayer
        if let cirLayer = findLayer(with: circleProgressName) as? CAShapeLayer {
            mProgressLayer = cirLayer
        } else {
            mProgressLayer = CAShapeLayer()
            mProgressLayer.name = circleProgressName
            layer.addSublayer(mProgressLayer)
        }
        var colors: [UIColor] = []
        if let color = startColor {
            colors.append(color)
        }
        if let color = endColor {
            colors.append(color)
        }
        let style = CNManager.shared.style.progress
        if colors.isEmpty {
            
            colors = [style.startColor, style.endColor]
        }
        let strokeColor: UIColor
        if let color = generateLinearGradientColor(colors: colors, direction: .vertical, rect: bounds) {
            strokeColor = color
        } else {
            strokeColor = style.startColor
        }
        mProgressLayer.frame = frame
        mProgressLayer.path = path
        mProgressLayer.strokeColor = strokeColor.cgColor
        mProgressLayer.lineWidth = mBackgroundLayer.lineWidth
        mProgressLayer.lineCap = .round
        mProgressLayer.fillColor = UIColor.clear.cgColor
        mProgressLayer.strokeStart = 0
        mProgressLayer.strokeEnd = 1
    }
    
    private func getCircleFrame() -> CGRect {
        let mWidth: CGFloat
        let mX: CGFloat
        let mY: CGFloat
        if bounds.width >= bounds.height {
            mWidth = bounds.width - lineWidth
            mX = lineWidth/2
            mY = (bounds.width - bounds.height)/2 + lineWidth/2
        } else {
            mWidth = bounds.height - lineWidth
            mX = (bounds.height - bounds.width)/2 + lineWidth/2
            mY = lineWidth/2
        }
        return CGRect(x: mX, y: mY, width: mWidth, height: mWidth)
    }
}

#endif
