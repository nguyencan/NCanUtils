//
//  UIView_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - UIView:Properties
public extension UIView {
    
    /// NCanUtils: Recursively find the first responder.
    var firstResponder: UIView? {
        var views = [UIView](arrayLiteral: self)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }
    
    /// NCanUtils: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// NCanUtils: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// NCanUtils: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    /// NCanUtils: Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// NCanUtils: Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// NCanUtils: Origin of view.
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }

    /// NCanUtils: x origin of view.
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    /// NCanUtils: y origin of view.
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}

// MARK: - UIView:Functions
public extension UIView {

    /// NCanUtils: Find layer with name if have
    ///
    /// - Parameter name: name of layer
    func findLayer(with name: String) -> CALayer? {
        if let layers = self.layer.sublayers {
            for item in layers {
                if name == item.name {
                    return item
                }
            }
        }
        return nil
    }
    
    /// NCanUtils: Remove layer with name
    ///
    /// - Parameter name: name of layer
    func removeLayer(name: String) {
        if let layers = self.layer.sublayers {
            for item in layers {
                if name == item.name {
                    item.removeFromSuperlayer()
                }
            }
        }
    }
    
    /// NCanUtils: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /// NCanUtils: Remove all subviews in view.
    func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /// NCanUtils: Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeIn(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil)
    {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// NCanUtils: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeOut(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil)
    {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    /// NCanUtils: Remove all gesture recognizers from view.
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    /// NCanUtils: Attaches gesture recognizers to the view. Attaching gesture recognizers to a view defines the scope of the represented gesture, causing it to receive touches hit-tested to that view and all of its subviews. The view establishes a strong reference to the gesture recognizers.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be added to the view.
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            addGestureRecognizer(recognizer)
        }
    }

    /// NCanUtils: Detaches gesture recognizers from the receiving view. This method releases gestureRecognizers in addition to detaching them from the view.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be removed from the view.
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            removeGestureRecognizer(recognizer)
        }
    }
    
    /// NCanUtils: Hide view
    ///
    func hide() {
        alpha = 0
        if let constraint = getHeightConstraint() {
            constraint.constant = 0
        }
    }
    
    /// NCanUtils: Show view with height
    ///
    /// - Parameter height: default height
    func show(default height: CGFloat) {
        alpha = 1
        if let constraint = getHeightConstraint() {
            constraint.constant = height
        }
    }
    
    /// NCanUtils: Get height constraint if have
    ///
    func getHeightConstraint() -> NSLayoutConstraint? {
        return self.constraints.filter { (constraint) -> Bool in
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .height, constraint.secondItem == nil {
                return true
            }
            return false
            }.first
    }
}

// MARK: - UIView:RoundedCorners Functions
public extension UIView {
    
    /// NCanUtils: Remove rounded corners from view
    func removeRounded() {
        layer.cornerRadius = 0
        checkAndUpdateRoundedStyle(corners: .allCorners, radius: 0)
    }
    
    /// NCanUtils: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func addRoundCorners(
        _ corners: UIRectCorner = .allCorners,
        radius: CGFloat = CNManager.shared.style.cornerRadius)
    {
        layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        }
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        layer.shadowPath = maskPath.cgPath
        // Update CornerStyle if needs
        checkAndUpdateRoundedStyle(corners: corners, radius: radius)
    }
    
    /// NCanUtils: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - position: position of view in list.
    func addDefaultRounded(_ position: Position = .unique) {
        switch position {
        case .unique:
            addRoundCorners(.allCorners)
            break
        case .center:
            addRoundCorners(.allCorners, radius: 0)
            break
        case .top:
            addRoundCorners([.topLeft, .topRight])
            break
        case .bottom:
            addRoundCorners([.bottomLeft, .bottomRight])
            break
        }
    }
    
    private func checkAndUpdateRoundedStyle(
        corners: UIRectCorner,
        radius: CGFloat)
    {
        if let view = self as? DesignableView {
            view.corners = CornerStyle(corners: corners, radius: radius)
         } else if let view = self as? DesignableLabel {
            view.corners = CornerStyle(corners: corners, radius: radius)
         } else if let view = self as? DesignableButton {
            view.corners = CornerStyle(corners: corners, radius: radius)
        } else if let view = self as? DesignableControl {
            view.corners = CornerStyle(corners: corners, radius: radius)
        }
    }
}

// MARK: - UIView:Border Functions
public extension UIView {
    
    private static let borderLayerName = "NCanUtils:BorderLayerName"
    
    func removeBorderLayer() {
        removeLayer(name: UIView.borderLayerName)
    }
    
    func addBorder(
        colors: [UIColor],
        direction: Direction = .vertical,
        width: CGFloat = CNManager.shared.style.borderWidth,
        radius: CGFloat = CNManager.shared.style.cornerRadius,
        corners: UIRectCorner = .allCorners)
    {
        if checkAndUpdateBorderStyle(colors: colors, direction: direction, width: width, length: 0, space: 0, radius: radius, corners: corners) {
            // Remove old border layer
            removeLayer(name: UIView.borderLayerName)
            // No needs draw anymore
            return
        }
        if let color = generateLinearGradientColor(colors: colors, direction: direction, rect: bounds) {
            addBorder(color: color, width: width, radius: radius, corners: corners)
        }
    }
    
    func addBorder(
        color: UIColor,
        width: CGFloat = CNManager.shared.style.borderWidth,
        radius: CGFloat = CNManager.shared.style.cornerRadius,
        corners: UIRectCorner = .allCorners)
    {
        if checkAndUpdateBorderStyle(colors: [color], width: width, length: 0, space: 0, radius: radius, corners: corners) {
            // Remove old border layer
            removeLayer(name: UIView.borderLayerName)
            // No needs draw anymore
            return
        }
        addBorderByDashed(color: color, width: width, length: width, space: 0, radius: radius, corners: corners)
    }
    
    func addBorderByDashed(
        colors: [UIColor],
        direction: Direction = .vertical,
        width: CGFloat = CNManager.shared.style.borderWidth,
        length: CGFloat = CNManager.shared.style.borderLength,
        space: CGFloat = CNManager.shared.style.borderSpace,
        radius: CGFloat = CNManager.shared.style.cornerRadius,
        corners: UIRectCorner = .allCorners)
    {
        if checkAndUpdateBorderStyle(colors: colors, direction: direction, width: width, length: length, space: space, radius: radius, corners: corners) {
            // Remove old border layer
            removeLayer(name: UIView.borderLayerName)
            // No needs draw anymore
            return
        }
        
        if let color = generateLinearGradientColor(colors: colors, direction: direction, rect: bounds) {
            addBorderByDashed(color: color, width: width, length: length, space: space, radius: radius, corners: corners)
        }
    }
    
    func addBorderByDashed(
        color: UIColor,
        width: CGFloat = CNManager.shared.style.borderWidth,
        length: CGFloat = CNManager.shared.style.borderLength,
        space: CGFloat = CNManager.shared.style.borderSpace,
        radius: CGFloat = CNManager.shared.style.cornerRadius,
        corners: UIRectCorner = .allCorners)
    {
        if checkAndUpdateBorderStyle(colors: [color], width: width, length: length, space: space, radius: radius, corners: corners) {
            // Remove old border layer
            removeLayer(name: UIView.borderLayerName)
            // No needs draw anymore
            return
        }
        
        // Remove old border layer
        removeLayer(name: UIView.borderLayerName)
        
        let borderLayer = CAShapeLayer()
        borderLayer.name = UIView.borderLayerName
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = [length, space] as [NSNumber]
        borderLayer.lineWidth = width
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        
        let rect = bounds.inset(by: UIEdgeInsets(top: width/2, left: width/2, bottom: width/2, right: width/2))
        let path: UIBezierPath
        if radius > 0 {
            path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        } else {
            path = UIBezierPath(rect: rect)
        }
        borderLayer.path = path.cgPath
        borderLayer.cornerRadius = radius
        borderLayer.masksToBounds = true
        
        layer.addSublayer(borderLayer)
        layer.cornerRadius = radius
    }
    
    func addBorderBySide(
        _ side: Side,
        colors: [UIColor],
        direction: Direction = .vertical,
        width: CGFloat = CNManager.shared.style.borderWidth)
    {
        checkAndUpdateBorderStyle(side: side, colors: colors, direction: direction, width: width, length: 0, space: 0, radius: 0, corners: .allCorners)
        if let color = generateLinearGradientColor(colors: colors, direction: direction, rect: bounds) {
            // Remove old border layer
            removeLayer(name: UIView.borderLayerName)
            
            let borderLayer = CALayer()
            borderLayer.backgroundColor = color.cgColor
            borderLayer.name = UIView.borderLayerName
            switch side {
            case .left:
                borderLayer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: frame.height)
                break
            case .right:
                borderLayer.frame = CGRect(x: frame.width - width, y: 0.0, width: width, height: frame.height)
                break
            case .top:
                borderLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: width)
                break
            case .bottom:
                borderLayer.frame = CGRect(x: 0.0, y: frame.height - width, width: frame.width, height: width)
                break
            }
            layer.addSublayer(borderLayer)
        }
    }
    
    @discardableResult
    private func checkAndUpdateBorderStyle(
        side: Side? = nil,
        colors: [UIColor],
        direction: Direction = .vertical,
        width: CGFloat,
        length: CGFloat,
        space: CGFloat,
        radius: CGFloat,
        corners: UIRectCorner) -> Bool
    {
        if let view = self as? DesignableView {
             view.corners = CornerStyle(corners: corners, radius: radius)
            view.border = BorderStyle(side: side, colors: colors, direction: direction, width: width, length: length, space: space)
             
             return true
         } else if let view = self as? DesignableLabel {
             view.corners = CornerStyle(corners: corners, radius: radius)
             view.border = BorderStyle(side: side, colors: colors, direction: direction, width: width, length: length, space: space)
             
             return true
         } else if let view = self as? DesignableButton {
            view.corners = CornerStyle(corners: corners, radius: radius)
            view.border = BorderStyle(side: side, colors: colors, direction: direction, width: width, length: length, space: space)
            
            return true
        } else if let view = self as? DesignableControl {
             view.corners = CornerStyle(corners: corners, radius: radius)
             view.border = BorderStyle(side: side, colors: colors, direction: direction, width: width, length: length, space: space)

             return true
        }
        return false
    }
}

// MARK: - UIView:Background Functions
public extension UIView {
    
    private static let backgroundLayerName = "NCanUtils:BackgroundLayerName"
    
    func removeGradientBackground() {
        removeLayer(name: UIView.backgroundLayerName)
    }
    
    func addGradientBackground(
        colors: [UIColor] = [],
        direction: Direction = .vertical,
        radius: CGFloat = CNManager.shared.style.cornerRadius,
        corners: UIRectCorner = .allCorners)
    {
        if checkAndUpdateBackgroundStyle(colors: colors, direction: direction, radius: radius, corners: corners) {
            // Remove old background layer
            removeLayer(name: UIView.backgroundLayerName)
            // No needs draw anymore
            return
        }
        
        // Remove old background layer
        removeLayer(name: UIView.backgroundLayerName)
        
        // Create background layer with fill gradient color
        let gradientLayer = createGradientLayer(colors: colors, width: 0, direction: direction, rect: bounds, radius: radius, corners: corners, fillColor: true)
        gradientLayer.name = UIView.backgroundLayerName
        
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = radius
        backgroundColor = .clear
    }
    
    func checkAndUpdateBackgroundStyle(
        colors: [UIColor],
        direction: Direction,
        radius: CGFloat,
        corners: UIRectCorner) -> Bool
    {
        if colors.count > 0 {
            if let view = self as? DesignableView {
                view.background = GradientStyle(colors: colors, direction: direction)
                view.corners = CornerStyle(corners: corners, radius: radius)
                
                return true
            } else if let view = self as? DesignableLabel {
                view.background = GradientStyle(colors: colors, direction: direction)
                view.corners = CornerStyle(corners: corners, radius: radius)
                
                return true
            } else if let view = self as? DesignableButton {
               view.background = GradientStyle(colors: colors, direction: direction)
               view.corners = CornerStyle(corners: corners, radius: radius)
               
               return true
           } else if let view = self as? DesignableControl {
                view.background = GradientStyle(colors: colors, direction: direction)
                view.corners = CornerStyle(corners: corners, radius: radius)

                return true
            }
        }
        return false
    }
}

// MARK: - UIView:Shadow Functions
public extension UIView {
    
    /// NCanUtils: Remove shadow from view
    func removeShadow() {
        layer.shadowColor = nil
    }

    /// NCanUtils: Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color
    ///   - radius: shadow radius
    ///   - offset: shadow offset
    ///   - opacity: shadow opacity
    func addShadow(
        color: UIColor = CNManager.shared.style.shadowColor,
        radius: CGFloat = CNManager.shared.style.shadowBlur/2,
        offset: CGSize = CNManager.shared.style.shadowOffset,
        opacity: Float = CNManager.shared.style.shadowAlpha)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowSpread = 0
        layer.masksToBounds = false
    }
    
    func addDefaultShadow(_ position: Position = .unique) {
        switch position {
        case .unique, .center:
            addSketchShadow()
            break
        case .top:
            addSketchShadow(x: 0, y: 4, blur: CNManager.shared.style.shadowBlur/2)
            break
        case .bottom:
            addSketchShadow(x: 0, y: -4, blur: CNManager.shared.style.shadowBlur/2)
            break
        }
    }
    
    func addSketchShadow(
        color: UIColor = CNManager.shared.style.shadowColor,
        alpha: Float = CNManager.shared.style.shadowAlpha,
        x: CGFloat = CNManager.shared.style.shadowOffset.width,
        y: CGFloat = CNManager.shared.style.shadowOffset.height,
        blur: CGFloat = CNManager.shared.style.shadowBlur,
        spread: CGFloat = CNManager.shared.style.shadowSpread)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowBlur = blur
        layer.shadowSpread = spread
        layer.masksToBounds = false
    }
}

// MARK: - UIView:Private Functions
extension UIView {
    
    func drawBackgroundIfNeeds(
        style: GradientStyle = GradientStyle(),
        rounded: CornerStyle = CornerStyle())
    {
        if let color = generateLinearGradientColor(colors: style.colors, locations: style.locations, direction: style.direction, rect: bounds) {
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.saveGState()
            
            let path: UIBezierPath
            if rounded.radius > 0 {
                path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rounded.corners, cornerRadii: CGSize(width: rounded.radius, height: rounded.radius))
            } else {
                path = UIBezierPath(rect: bounds)
            }
            context.addPath(path.cgPath)
            context.setFillColor(color.cgColor)
            context.closePath()
            context.fillPath()
            
            context.restoreGState()
        }
    }
    
    func drawBorderIfNeeds(
        style: BorderStyle = BorderStyle(),
        rounded: CornerStyle = CornerStyle())
    {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        if let side = style.side {
            addBorderBySide(side, colors: style.colors, direction: style.direction, width: style.width)
            return
        }
        if style.width > 0, let color = generateLinearGradientColor(colors: style.colors, direction: style.direction, rect: bounds) {
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            
            let inset = style.width/2
            let rect = bounds.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
            let path: UIBezierPath
            if rounded.radius > 0 {
                path = UIBezierPath(roundedRect: rect, byRoundingCorners: rounded.corners, cornerRadii: CGSize(width: rounded.radius, height: rounded.radius))
            } else {
                path = UIBezierPath(roundedRect: rect, cornerRadius: rounded.radius)
            }
            UIColor.clear.setFill()
            path.fill()
            
            color.setStroke()
            path.lineWidth = style.width
            
            if style.length > 0 {
                let dashPattern: [CGFloat]
                let lineCapStyle: CGLineCap
                if style.length == style.width {
                    dashPattern = [0, style.space]
                    lineCapStyle = .round
                } else {
                    dashPattern = [style.length, style.space]
                    lineCapStyle = .butt
                }
                path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
                path.lineCapStyle = lineCapStyle
            }
            path.stroke()
            
            context?.restoreGState()
        }
    }
    
    func createGradientLayer(
        colors: [UIColor],
        width: CGFloat,
        direction: Direction,
        rect: CGRect,
        radius: CGFloat,
        corners: UIRectCorner = .allCorners,
        fillColor: Bool) -> CAGradientLayer
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        
        let path: UIBezierPath
        if radius > 0 {
            path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        } else {
            path = UIBezierPath(rect: rect)
        }
        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        if !fillColor {
            shape.fillColor = nil
        }
        shape.masksToBounds = false
        
        gradientLayer.mask = shape
        gradientLayer.cornerRadius = radius
        gradientLayer.masksToBounds = false
        
        let cgColors: [CGColor]
        if colors.isEmpty {
            return gradientLayer
        } else {
            cgColors = colors.map({ (color) -> CGColor in
                return color.cgColor
            })
        }
        gradientLayer.colors = cgColors
        if direction == .vertical {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }

        return gradientLayer
    }
    
    func generateLinearGradientColor(
        colors: [UIColor],
        locations: UnsafePointer<CGFloat>? = nil,
        direction: Direction,
        rect: CGRect) -> UIColor?
    {
        if colors.count < 2 {
            return colors.first
        }
        if let currentContext = UIGraphicsGetCurrentContext() {
            currentContext.saveGState()
            do { currentContext.restoreGState() }
        }
        
        let resultColors: [CGColor] = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: resultColors as CFArray,
                                        locations: locations) else { return nil }
        
        let point: CGPoint
        if direction == .vertical {
            point = CGPoint(x: size.width, y: 0)
        } else {
            point = CGPoint(x: 0, y: size.height)
        }
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: .zero,
                                    end: point,
                                    options: [])
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        
        return UIColor(patternImage: image)
    }
    
    func generateRadialGradientColor(in rect: CGRect, colors: [UIColor]) -> UIColor? {
        if colors.count < 2 {
            return colors.first
        }
        if let currentContext = UIGraphicsGetCurrentContext() {
            currentContext.saveGState()
            do { currentContext.restoreGState() }
        }
        
        let resultColors: [CGColor] = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB()
            , colors: resultColors as CFArray
            , locations: [0.0, 1.0]) else { return nil }
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient
            , startCenter: CGPoint(x: rect.midX, y: rect.midY)
            , startRadius: 0
            , endCenter: CGPoint(x: rect.midX, y: rect.midY)
            , endRadius: min(rect.width, rect.height)
            , options: [])
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        
        return UIColor(patternImage: image)
    }
}

#endif
