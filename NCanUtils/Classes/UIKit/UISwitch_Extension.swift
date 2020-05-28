//
//  UISwitch_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/30/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)  && os(iOS)
import UIKit

// MARK: - Methods
public extension UISwitch {

    /// NCanUtils: Toggle a UISwitch
    ///
    /// - Parameter animated: set true to animate the change (default is true)
    func toggle(animated: Bool = true) {
        setOn(!isOn, animated: animated)
    }
}

#endif
