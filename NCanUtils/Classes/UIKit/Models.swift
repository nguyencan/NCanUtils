//
//  Models.swift
//  NCanUtils
//
//  Created by Nguyen Can on 7/9/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import UIKit

public struct BackgroundStyle {
    var colors: [UIColor]
    var direction: Direction
    
    public init(colors: [UIColor] = [], direction: Direction = .vertical) {
        self.colors = colors
        self.direction = direction
    }
}

public struct BorderStyle {
    var colors: [UIColor]
    var direction: Direction
    var width: CGFloat
    var length: CGFloat
    var space: CGFloat
    
    public init(colors: [UIColor] = [], direction: Direction = .vertical, width: CGFloat = 1, length: CGFloat = 0, space: CGFloat = 0) {
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
    case left, right, top, bottom
}
