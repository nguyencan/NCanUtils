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

public enum Position: Int {
    case unique = 0
    case top = 1
    case bottom = 2
    case center = 3
    
    init() {
        self = .unique
    }
    
    public init(rawValue value: Int) {
        var result: Position = .unique
        switch value {
        case Position.unique.rawValue:
            result = .unique
            break
        case Position.center.rawValue:
            result = .center
            break
        case Position.top.rawValue:
            result = .top
            break
        case Position.bottom.rawValue:
            result = .bottom
            break
        default:
            result = .unique
        }
        self = result
    }
}

public enum DrawStyle: Int {
    case fill, line
}
