//
//  NoteEditBar.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/23/21.
//

import SwiftUI

enum EditButtons: Int {
    case bold, italics, underline, strikethrough, bullets, image
}

struct NoteEditBar: View {

    @Binding var subMenuShown         : Bool
    @Binding var boldHovered          : Bool
    @Binding var italicsHovered       : Bool
    @Binding var underlineHovered     : Bool
    @Binding var strikethroughHovered : Bool
    @Binding var bulletsHovered       : Bool
    @Binding var imageHovered         : Bool
    @Binding var boldToggled          : Bool
    @Binding var italicsToggled       : Bool
    @Binding var underlineToggled     : Bool
    @Binding var strikethroughToggled : Bool
    @Binding var bulletsToggled       : Bool
    @Binding var imageToggled         : Bool

    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: 8) {
                EditButtonView(subMenuShown: self.$subMenuShown, button: EditButtons.bold, buttonToggled: self.$boldToggled, imageSystemName: "bold", localKey: "local_bold")
                EditButtonView(subMenuShown: self.$subMenuShown, button: EditButtons.italics, buttonToggled: self.$italicsToggled, imageSystemName: "italic", localKey: "local_italic")
                EditButtonView(subMenuShown: self.$subMenuShown, button: EditButtons.underline, buttonToggled: self.$underlineToggled, imageSystemName: "underline", localKey: "local_underline")
                EditButtonView(subMenuShown: self.$subMenuShown, button: EditButtons.strikethrough, buttonToggled: self.$strikethroughToggled, imageSystemName: "strikethrough", localKey: "local_strikethrough")
                EditButtonView(subMenuShown: self.$subMenuShown, button: EditButtons.bullets, buttonToggled: self.$bulletsToggled, imageSystemName: "list.bullet", localKey: "local_bullet")
                EditButtonView(subMenuShown: self.$subMenuShown, button: EditButtons.image, buttonToggled: self.$imageToggled, imageSystemName: "photo", localKey: "local_image")
            }
            .padding(8)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(RoundedCorners(tl: 7, tr: 7, bl: 7, br: 7).fill(Color(hex: 0xFFFFFF).opacity(0.03)))
        .padding([.leading, .trailing, .bottom], 9)
        .opacity(self.subMenuShown ? 0.5 : 1.0)
        .disabled(self.subMenuShown ? true : false)
    }
}

struct EditButtonView: View {
    @Binding var subMenuShown  : Bool
    var button                 : EditButtons
    @Binding var buttonToggled : Bool
    var imageSystemName        : String
    var localKey               : String

    var body: some View {
        Button(action: {
            self.buttonToggled.toggle()
            handleButtonToggle(button: button)
        }) {
            EditBarButtonImage(imageSystemName: self.imageSystemName, settingsShown: .constant(true), fontColor: Color.gray)
                .help(self.localKey.localized())
        }
        .modifier(RoundedButtonModifier_Toggle(buttonToggled: self.$buttonToggled, subMenuShown: self.$subMenuShown, defaultBackground: Color(hex: 0xFFFFFF).opacity(0.0), hoveredBackground: Color(hex: 0xFFFFFF).opacity(0.08)))
    }

    func handleButtonToggle(button: EditButtons) {

    }
}

struct EditBarButtonImage: View {
    var imageSystemName        : String
    @Binding var settingsShown : Bool
    var fontColor              : Color
    var fontSize               : CGFloat = 17

    var body: some View {
        HStack {
            Spacer()
            Image(systemName: self.imageSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: self.fontSize, height: self.fontSize)
//                .frame(minWidth: self.fontSize, maxWidth: .infinity, minHeight: self.fontSize, maxHeight: .infinity, alignment: .center)
                .foregroundColor(self.fontColor)
                .padding([.top, .bottom], 6)
                .rotationEffect(self.settingsShown ? .degrees(0) : .degrees(90))
            Spacer()
        }
        .contentShape(RoundedRectangle(cornerSize: CGSize(width: 7, height: 7)))
    }
}
