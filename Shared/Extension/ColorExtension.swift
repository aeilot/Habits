//
//  ColorExtension.swift
//  Habits
//
//  Created by Chenluo Deng on 8/20/25.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftUI

extension Color {
    /// Returns the hex string (e.g. "FFAA00") for this Color, or nil if conversion fails.
    #if os(macOS)
    func toHexString() -> String? {
        let nsColor = NSColor(self).usingColorSpace(.deviceRGB)
        guard let nsColor = nsColor else { return nil }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        let red = Int(r * 255)
        let green = Int(g * 255)
        let blue = Int(b * 255)
        return String(format: "%02X%02X%02X", red, green, blue)
    }
    #else
    func toHexString() -> String? {
        guard let uiColor = UIColor(self).cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil),
              let components = uiColor.components, components.count >= 3 else { return nil }
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        return String(format: "%02X%02X%02X", red, green, blue)
    }
    #endif

    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        if scanner.scanHexInt64(&rgbValue) {
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff
            self.init(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0
            )
        } else {
            self.init(red: 0, green: 0, blue: 0) // fallback to black
        }
    }
}
