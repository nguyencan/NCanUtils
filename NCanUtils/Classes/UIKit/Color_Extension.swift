//
//  Color_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public typealias Color = UIColor

// MARK: - Properties
public extension Color {

    /// NCanUtils: Random color.
    static var random: Color {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return Color(red: red, green: green, blue: blue)
    }

    /// NCanUtils: RGB components for a Color (between 0 and 255).
    ///
    ///     UIColor.red.rgbComponents.red -> 255
    ///     NSColor.green.rgbComponents.green -> 255
    ///     UIColor.blue.rgbComponents.blue -> 255
    ///
    var rgbComponents: (red: Int, green: Int, blue: Int) {
        var components: [CGFloat] {
            let comps = cgColor.components!
            if comps.count == 4 { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: Int(red * 255.0), green: Int(green * 255.0), blue: Int(blue * 255.0))
    }
    
    /// NCanUtils: RGB components for a Color represented as CGFloat numbers (between 0 and 1)
    ///
    ///     UIColor.red.rgbComponents.red -> 1.0
    ///     NSColor.green.rgbComponents.green -> 1.0
    ///     UIColor.blue.rgbComponents.blue -> 1.0
    ///
    var cgFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var components: [CGFloat] {
            let comps = cgColor.components!
            if comps.count == 4 { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: red, green: green, blue: blue)
    }
    
    /// NCanUtils: Get components of hue, saturation, and brightness, and alpha (read-only).
    var hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// NCanUtils: Hexadecimal value string (read-only).
    var hexString: String {
        let components: [Int] = {
            let comps = cgColor.components!
            let components = comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }

    /// NCanUtils: Short hexadecimal value string (read-only, if applicable).
    var shortHexString: String? {
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    /// NCanUtils: Short hexadecimal value string, or full hexadecimal string if not possible (read-only).
    var shortHexOrHexString: String {
        let components: [Int] = {
            let comps = cgColor.components!
            let components = comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
            return components.map { Int($0 * 255.0) }
        }()
        let hexString = String(format: "#%02X%02X%02X", components[0], components[1], components[2])
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return hexString }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    /// NCanUtils: Alpha of Color (read-only).
    var alpha: CGFloat {
        return cgColor.alpha
    }

    #if !os(watchOS)
    /// NCanUtils: CoreImage.CIColor (read-only)
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }
    #endif

    /// NCanUtils: Get UInt representation of a Color (read-only).
    var uInt: UInt {
        let comps: [CGFloat] = {
            let comps = cgColor.components!
            return comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
        }()

        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(comps[0] * 255.0) << 16
        colorAsUInt32 += UInt32(comps[1] * 255.0) << 8
        colorAsUInt32 += UInt32(comps[2] * 255.0)

        return UInt(colorAsUInt32)
    }

    /// NCanUtils: Get color complementary (read-only, if applicable).
    var complementary: Color? {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: Color) -> Color?) = { color -> Color? in
            if self.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = self.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = Color(cgColor: colorRef!)
                return colorOut
            } else {
                return self
            }
        }

        let color = convertColorToRGBSpace(self)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255

        return Color(red: red, green: green, blue: blue, alpha: 1.0)
    }

}

// MARK: - Methods
public extension Color {

    /// NCanUtils: Blend two Colors
    ///
    /// - Parameters:
    ///   - color1: first color to blend
    ///   - intensity1: intensity of first color (default is 0.5)
    ///   - color2: second color to blend
    ///   - intensity2: intensity of second color (default is 0.5)
    /// - Returns: Color created by blending first and seond colors.
    static func blend(_ color1: Color, intensity1: CGFloat = 0.5, with color2: Color, intensity2: CGFloat = 0.5) -> Color {
        let total = intensity1 + intensity2
        let level1 = intensity1/total
        let level2 = intensity2/total

        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }

        let components1: [CGFloat] = {
            let comps = color1.cgColor.components!
            return comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
        }()

        let components2: [CGFloat] = {
            let comps = color2.cgColor.components!
            return comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
        }()

        let red1 = components1[0]
        let red2 = components2[0]

        let green1 = components1[1]
        let green2 = components2[1]

        let blue1 = components1[2]
        let blue2 = components2[2]

        let alpha1 = color1.cgColor.alpha
        let alpha2 = color2.cgColor.alpha

        let red = level1*red1 + level2*red2
        let green = level1*green1 + level2*green2
        let blue = level1*blue1 + level2*blue2
        let alpha = level1*alpha1 + level2*alpha2

        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// NCanUtils: Lighten a color
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let lighterColor: Color = color.lighten(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to lighten the color
    /// - Returns: A lightened color
    func lighten(by percentage: CGFloat = 0.2) -> Color {
        return adjust(by: abs(percentage))
    }

    /// NCanUtils: Darken a color
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let darkerColor: Color = color.darken(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to darken the color
    /// - Returns: A darkened color
    func darken(by percentage: CGFloat = 0.2) -> Color {
        return adjust(by: -1*abs(percentage))
    }
    
    /// NCanUtils: Adjust a color
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let darkerColor: Color = color.adjust(by: -0.2)
    ///     let lighterColor: Color = color.adjust(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to adjust the color
    /// - Returns: A darkened color
    func adjust(by percentage: CGFloat = 0.2) -> Color {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color(red: max(red + percentage, 1),
                     green: max(green + percentage, 1),
                     blue: max(blue + percentage, 1),
                     alpha: alpha)
    }

}

// MARK: - Initializers
public extension Color {

    /// NCanUtils: Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        var hred: CGFloat
        if red < 0 {
            hred = 0
        } else if red > 255 {
            hred = 255
        } else {
            hred = CGFloat(red)
        }
        hred = hred / 255.0
        
        var hgreen: CGFloat
        if green < 0 {
            hgreen = 0
        } else if green > 255 {
            hgreen = 255
        } else {
            hgreen = CGFloat(green)
        }
        hgreen = hgreen / 255.0
        
        var hblue: CGFloat
        if blue < 0 {
            hblue = 0
        } else if blue > 255 {
            hblue = 255
        } else {
            hblue = CGFloat(blue)
        }
        hblue = hblue / 255.0

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        self.init(red: hred, green: hgreen, blue: hblue, alpha: trans)
    }

    /// NCanUtils: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    convenience init(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    /// NCanUtils: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    /// NCanUtils: Create Color from a complementary of a Color (if applicable).
    ///
    /// - Parameter color: color of which opposite color is desired.
    convenience init?(complementaryFor color: Color) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: Color) -> Color?) = { color -> Color? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = Color(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }

        let color = convertColorToRGBSpace(color)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

#endif
