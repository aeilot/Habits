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
        let nsColor = NSColor(self)

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        let red = Int(r * 255)
        let green = Int(g * 255)
        let blue = Int(b * 255)
        let alpha = Int(a * 255)

        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }
}
