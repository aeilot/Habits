//
//  ColorExtension.swift
//  Habits
//
//  Created by 邓陈珞 on 8/20/25.
//

import Foundation
import AppKit
import SwiftUI

extension Color {
    func toHexString() -> String? {
        let nsColor = NSColor(self).usingColorSpace(.deviceRGB)

        guard (nsColor != nil) else { return nil }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        nsColor?.getRed(&r, green: &g, blue: &b, alpha: &a)

        let red = Int(r * 255)
        let green = Int(g * 255)
        let blue = Int(b * 255)
        let alpha = Int(a * 255)

        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff
        )
    }

}
