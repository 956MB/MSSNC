//
//  Color+Ext.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/21/21.
//

import SwiftUI

extension Color {
    /// Returns custom color from supplied hexadecimal
    /// - Parameters:
    ///   - hex: hex code, UInt
    ///   - alpha: color alpha, Double
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
