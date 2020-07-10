//
//  UIButton_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIButton {
    
    private func actionHandler(action:(() -> Void)? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    
    /// NCanUtils: Add action for button
    ///
    func actionHandler(controlEvents control: UIControl.Event, ForAction action: @escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
    
    /// NCanUtils: Set font size for button
    ///
    /// - Parameter size: CGFloat
    func setFontSize(_ size: CGFloat) {
        if let label = titleLabel, let font = label.font {
            label.font = font.withSize(size)
        }
    }
}

#endif
