//
//  CGRect_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Properties
public extension CGRect {

    /// NCanUtils: Return center of rect
    var center: CGPoint { CGPoint(x: midX, y: midY) }

}

// MARK: - Initializers
public extension CGRect {

    /// NCanUtils: Create a `CGRect` instance with center and size
    /// - Parameters:
    ///   - center: center of the new rect
    ///   - size: size of the new rect
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        self.init(origin: origin, size: size)
    }

    init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }
}

// MARK: - Methods
public extension CGRect {

    /// NCanUtils: Create a new `CGRect` by resizing with specified anchor
    /// - Parameters:
    ///   - size: new size to be applied
    ///   - anchor: specified anchor, a point in normalized coordinates -
    ///     '(0, 0)' is the top left corner of rect，'(1, 1)' is the bottom right corner of rect,
    ///     defaults to '(0.5, 0.5)'. excample:
    ///
    ///          anchor = CGPoint(x: 0.0, y: 1.0):
    ///
    ///                       A2------B2
    ///          A----B       |        |
    ///          |    |  -->  |        |
    ///          C----D       C-------D2
    ///
    func resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - width, height: size.height - height)
        return CGRect(origin: CGPoint(x: minX - sizeDelta.width * anchor.x,
                                      y: minY - sizeDelta.height * anchor.y),
                      size: size)
    }
    
    func addMargin(_ margin: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x + margin,
            y: origin.y + margin,
            width: size.width - 2*margin,
            height: size.height - 2*margin)
    }

    #if canImport(UIKit)
    func draw(style: DrawStyle = .fill, color: UIColor) {
        color.set()
        let path: UIBezierPath = UIBezierPath(rect: self)
        switch style {
        case .fill:
            path.fill()
            break
        case .line:
            path.stroke()
            break
        }
        
    }
    #endif
    
    #if canImport(UIKit)
    func getDrawRect(shape: CGSize, margin: CGFloat, mode: UIView.ContentMode) -> CGRect {
        getDrawRect(shape: shape, insets: UIEdgeInsets(inset: margin), mode: mode)
    }
    #endif
    
    #if canImport(UIKit)
    func getDrawRect(shape: CGSize, insets: UIEdgeInsets = .zero, mode: UIView.ContentMode) -> CGRect {
        let mRect: CGRect = self.inset(by: insets)
        let rSize: CGSize
        let rOrigin: CGPoint
        if mode == .center {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width)/2,
                y: mRect.origin.y + (mRect.height - rSize.height)/2)
        } else if mode == .top {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width)/2,
                y: mRect.origin.y)
        } else if mode == .bottom {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width)/2,
                y: mRect.origin.y + (mRect.height - rSize.height))
        } else if mode == .left {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x,
                y: mRect.origin.y + (mRect.height - rSize.height)/2)
        } else if mode == .right {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width),
                y: mRect.origin.y + (mRect.height - rSize.height)/2)
        } else if mode == .topLeft {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x,
                y: mRect.origin.y)
        } else if mode == .topRight {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width),
                y: mRect.origin.y)
        } else if mode == .bottomLeft {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x,
                y: mRect.origin.y + (mRect.height - rSize.height))
        } else if mode == .bottomRight {
            rSize = shape
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width),
                y: mRect.origin.y + (mRect.height - rSize.height))
        } else if mode == .redraw {
            if shape.width > mRect.width || shape.height > mRect.height {
                let wRadio: CGFloat = shape.width/mRect.width
                let hRadio: CGFloat = shape.height/mRect.height
                let raido: CGFloat = (wRadio > hRadio) ? wRadio : hRadio
                rSize = CGSize(
                    width: shape.width/raido,
                    height: shape.height/raido)
            } else {
                rSize = shape
            }
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width)/2,
                y: mRect.origin.y + (mRect.height - rSize.height)/2)
        } else if mode == .scaleAspectFit {
            let wRadio: CGFloat = shape.width/mRect.width
            let hRadio: CGFloat = shape.height/mRect.height
            let raido: CGFloat = (wRadio > hRadio) ? wRadio : hRadio
            rSize = CGSize(
                width: shape.width/raido,
                height: shape.height/raido)
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - rSize.width)/2,
                y: mRect.origin.y + (mRect.height - rSize.height)/2)
        } else if mode == .scaleAspectFill {
            let wRadio: CGFloat = shape.width/mRect.width
            let hRadio: CGFloat = shape.height/mRect.height
            let width: CGFloat
            let height: CGFloat
            if wRadio > hRadio {
                height = mRect.height
                width = height*shape.width/shape.height
            } else {
                width = mRect.width
                height = width*shape.height/shape.width
            }
            rSize = CGSize(
                width: width,
                height: height)
            rOrigin = CGPoint(
                x: mRect.origin.x + (mRect.width - width)/2,
                y: mRect.origin.y + (mRect.height - height)/2)
        } else {
            rSize = self.size
            rOrigin = self.origin
        }
        return CGRect(origin: rOrigin, size: rSize)
    }
    #endif
}

#endif
