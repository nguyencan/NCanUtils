//
//  Models.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/9/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import UIKit

public struct GradientStyle {
    var colors: [UIColor]
    var locations: UnsafePointer<CGFloat>?
    var direction: Direction
    
    public init(colors: [UIColor] = [], locations: UnsafePointer<CGFloat>? = nil, direction: Direction = .vertical) {
        self.colors = colors
        self.locations = locations
        self.direction = direction
    }
}

public struct BorderStyle {
    var side: Side?
    var colors: [UIColor]
    var direction: Direction
    var width: CGFloat
    var length: CGFloat
    var space: CGFloat
    
    public init(side: Side? = nil, colors: [UIColor] = [], direction: Direction = .vertical, width: CGFloat = 1, length: CGFloat = 0, space: CGFloat = 0) {
        self.side = side
        self.colors = colors
        self.direction = direction
        self.width = width
        self.length = length
        self.space = space
    }
}

public struct CornerStyle {
    var radius: CGFloat
    var corners: UIRectCorner = .allCorners
    
    public init(corners: UIRectCorner = .allCorners, radius: CGFloat = 0) {
        self.radius = radius
        self.corners = corners
    }
}

public enum Direction: Int {
    case vertical, horizontal
}

public enum Side: Int {
    case top, bottom, left, right
}

public enum ShadowSide: Int {
    case center = 0
    case top = 1
    case bottom = 2
}

public enum GridPosition: Int {
    case unique = 0
    case top = 1
    case bottom = 2
    case left = 3
    case right = 4
    case center = 5
    case topLeft = 6
    case topRight = 7
    case bottomLeft = 8
    case bottomRight = 9
    
    init() {
        self = .unique
    }
    
    public init(rawValue value: Int) {
        var result: GridPosition = .unique
        switch value {
        case GridPosition.unique.rawValue:
            result = .unique
            break
        case GridPosition.center.rawValue:
            result = .center
            break
        case GridPosition.top.rawValue:
            result = .top
            break
        case GridPosition.topLeft.rawValue:
            result = .topLeft
            break
        case GridPosition.topRight.rawValue:
            result = .topRight
            break
        case GridPosition.bottom.rawValue:
            result = .bottom
            break
        case GridPosition.bottomLeft.rawValue:
            result = .bottomLeft
            break
        case GridPosition.bottomRight.rawValue:
            result = .bottomRight
            break
        case GridPosition.left.rawValue:
            result = .left
            break
        case GridPosition.right.rawValue:
            result = .right
            break
        default:
            result = .unique
        }
        self = result
    }
    
    func toSide() -> ShadowSide {
        switch self {
        case .unique, .center, .left, .right:
            return .center
        case .top, .topLeft, .topRight:
            return .top
        case .bottom, .bottomLeft, .bottomRight:
            return .bottom
        }
    }
    
    func toCorners(radius: CGFloat) -> CornerStyle {
        switch self {
        case .unique:
            return CornerStyle(corners: .allCorners, radius: radius)
        case .center:
            return CornerStyle(corners: .allCorners, radius: 0)
        case .top:
            return CornerStyle(corners: [.topLeft, .topRight], radius: radius)
        case .bottom:
            return CornerStyle(corners: [.bottomLeft, .bottomRight], radius: radius)
        case .left:
            return CornerStyle(corners: [.topLeft, .bottomLeft], radius: radius)
        case .right:
            return CornerStyle(corners: [.topRight, .bottomRight], radius: radius)
        case .topLeft:
            return CornerStyle(corners: [.topLeft], radius: radius)
        case .topRight:
            return CornerStyle(corners: [.topRight], radius: radius)
        case .bottomLeft:
            return CornerStyle(corners: [.bottomLeft], radius: radius)
        case .bottomRight:
            return CornerStyle(corners: [.bottomRight], radius: radius)
        }
    }
    
    func toOrigin(in rect: CGRect, size: CGSize) -> CGPoint {
        var x: CGFloat = (rect.width - size.width) / 2
        var y: CGFloat = (rect.height - size.width) / 2
        switch self {
        case .unique, .center:
            break
        case .top:
            y = 0
            break
        case .bottom:
            y = rect.height - size.height
            break
        case .left:
            x = 0
            break
        case .right:
            y = rect.width - size.width
            break
        case .topLeft:
            x = 0
            y = 0
            break
        case .topRight:
            x = rect.width - size.width
            y = 0
            break
        case .bottomLeft:
            x = 0
            y = rect.height - size.height
            break
        case .bottomRight:
            x = rect.width - size.width
            y = rect.height - size.height
        }
        return CGPoint(x: x, y: y)
    }
}

public enum DrawStyle: Int {
    case fill, line
}
