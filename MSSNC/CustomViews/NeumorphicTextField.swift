//
//  NeumorphicTextField.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/22/21.
//

import SwiftUI

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}
struct NeumorphicStyleTextField: View {
    var textField: TextField<Text>
    var body: some View {
        HStack {
            textField
                .foregroundColor(.primary)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(8)
        .foregroundColor(.secondary)
        .background(Color(hex: 0x414141))
        .cornerRadius(4)
//        .shadow(color: Color.black, radius: 3, x: 2, y: 2)
//        .shadow(color: Color.black, radius: 3, x: -2, y: -2)
    }
}
