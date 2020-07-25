//
//  CNProgressPointsView.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/13/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@IBDesignable
public class CNProgressPointsView: UIView {
    
    private final let progressLayerName = "ProgressLayerName"
    
    @IBInspectable public var startColor: UIColor? = nil {
        didSet {
            isNeedRedrawProgressLayer = true
        }
    }
    
    @IBInspectable public var endColor: UIColor? = nil {
        didSet {
            isNeedRedrawProgressLayer = true
        }
    }
    
    @IBInspectable public var pointCount: Int = 12 {
        didSet {
            isNeedRedrawProgressLayer = true
        }
    }
    
    @IBInspectable public var pointSize: CGFloat = 10 {
        didSet {
            isNeedRedrawProgressLayer = true
        }
    }
    
    @IBInspectable public var pointSpace: CGFloat = 2 {
        didSet {
            isNeedRedrawProgressLayer = true
        }
    }
    
    public var alignment: GridPosition = .center {
        didSet {
            isNeedRedrawProgressLayer = true
        }
    }
    
    public var isAnimation: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var isNeedRedrawProgressLayer: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    public func toggleAnimation() {
        isAnimation = !isAnimation
    }
    
    public func startAnimation() {
        isAnimation = true
    }
    
    public func stopAnimation() {
        isAnimation = false
    }
}

// MARK: - Override functions
extension CNProgressPointsView {
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        
        let width: CGFloat = getContainerSize()
        contentSize.width = width
        contentSize.height = width
        
        return contentSize
    }
    
    override public func draw(_ rect: CGRect) {
        doCirclePointsAnimation()
    }
}

// MARK: - Private functions
extension CNProgressPointsView {
    
    private func doCirclePointsAnimation() {
        if !isAnimation {
            // Remove old animation layer if needs
            // Then not do anymore
            if let rl = findLayer(with: progressLayerName) {
                rl.removeFromSuperlayer()
            }
            return
        }
        if let rl = findLayer(with: progressLayerName) {
            if !isNeedRedrawProgressLayer {
                // No needs redraw animation layer
                rl.isHidden = false
                
                return
            } else {
                // Remove old animtion layer to draw new one
                rl.removeFromSuperlayer()
            }
        }
        // Reset draw flag
        isNeedRedrawProgressLayer = false
        
        let duration: TimeInterval = 1.0
        let color: UIColor = getProgressColor()
        let angle = CGFloat.pi * 2 / CGFloat(pointCount)
        
        let width: CGFloat = getContainerSize()
        let size: CGSize = CGSize(width: width, height: width)
        let point: CGPoint = alignment.toOrigin(in: self.bounds, size: size)
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(origin: point, size: size)
        replicatorLayer.name = progressLayerName
        
        self.layer.addSublayer(replicatorLayer)
        
        let dot = CALayer()
        dot.bounds = CGRect(x: 0.0, y: 0.0, width: pointSize, height: pointSize)
        dot.position = CGPoint(x: replicatorLayer.bounds.width / 2, y: pointSize / 2)
        dot.backgroundColor = color.cgColor
        dot.cornerRadius = pointSize / 2
        replicatorLayer.addSublayer(dot)
        
        replicatorLayer.instanceCount = pointCount
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        
        let shrink = CABasicAnimation(keyPath: "transform.scale")
        shrink.fromValue = 1.0
        shrink.toValue = 0.1
        shrink.duration = duration
        shrink.repeatCount = Float.infinity
        
        dot.add(shrink, forKey: nil)
        
        replicatorLayer.instanceDelay = duration / TimeInterval(pointCount)
        dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
    }
    
    private func getContainerSize() -> CGFloat {
        let result = (CGFloat(pointCount) * (pointSize + pointSpace) / CGFloat.pi) + pointSize
        return result
    }
    
    private func getProgressColor() -> UIColor {
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
        let result: UIColor
        if let color = generateRadialGradientColor(in: CGRect(x: 0, y: 0, width: pointSize, height: pointSize), colors: colors) {
            result = color
        } else {
            result = style.startColor
        }
        return result
    }
}

#endif
