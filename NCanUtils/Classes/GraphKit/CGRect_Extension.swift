//
//  CGRect_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(CoreGraphics)
import CoreGraphics

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

}

#endif
