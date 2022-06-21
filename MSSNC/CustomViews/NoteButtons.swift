//
//  NoteButtons.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/22/21.
//

import SwiftUI
import AVFoundation

struct ButtonImage: View {
    @Binding var hovered : Bool
    var imageSystemName  : String
    var defaultFontColor : Color
    var hoveredFontColor : Color
    var fontSize         : CGFloat = 17
    var imageRotation    : Double

    var body: some View {
        HStack {
            Image(systemName: self.imageSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: self.fontSize, height: self.fontSize)
                .foregroundColor(self.hovered ? self.hoveredFontColor : self.defaultFontColor)
                .padding(6)
                .rotationEffect(.degrees(self.imageRotation))
        }
        .contentShape(RoundedRectangle(cornerSize: CGSize(width: 7, height: 7)))
    }
}

struct RoundedButtonModifier: ViewModifier {
    @State private var buttonHover : Bool = false
    var defaultBackground          : Color
    var hoveredBackground          : Color

    func body(content: Content) -> some View {
        return content
            .buttonStyle(PlainButtonStyle())
            .background(self.buttonHover ? self.hoveredBackground : self.defaultBackground)
            .onHover {_ in self.buttonHover.toggle()}
            .cornerRadius(7)
    }
}

struct RoundedButtonModifier_Toggle: ViewModifier {
    @State private var buttonHovered : Bool = false
    @Binding var buttonToggled       : Bool
    @Binding var subMenuShown        : Bool
    var defaultBackground            : Color
    var hoveredBackground            : Color

    func body(content: Content) -> some View {
        return content
            .buttonStyle(PlainButtonStyle())
            .background(self.getBG())
            .onHover {_ in self.subMenuShown ? {}() : self.buttonHovered.toggle()}
            .cornerRadius(7)
    }

    /// Returns button background based on button toggled or hovered
    /// - Returns: Color
    func getBG() -> Color {
        if (self.buttonToggled) {
            return self.hoveredBackground
        } else {
            if (self.buttonHovered) {
                return self.hoveredBackground
            }
        }
        return self.defaultBackground
    }
}

struct ToolbarButton: View {
    var buttonAction:     () -> Void
    @Binding var hover    : Bool
    var imageName         : String
    var helpKey           : String
    @Binding var accent   : Color
    var defaultBackground : Color
    var hoveredBackground : Color

    var body: some View {
        Button(action: {
            self.buttonAction()
        }) {
            ButtonImage(hovered: self.$hover, imageSystemName: self.imageName, defaultFontColor: ifYellowFG(accent: self.accent), hoveredFontColor: Color(hex: 0x9b9b9b), fontSize: 14, imageRotation: 0)
                .help(self.helpKey.localized())
        }
        .modifier(RoundedButtonModifier(defaultBackground: self.defaultBackground, hoveredBackground: self.hoveredBackground))
    }
}

struct ToolbarButtonsStack: View {

    @EnvironmentObject var noteWindowProperties : NoteWindowProperties
    @StateObject var MSSNCGlobal                = MSSNCGlobalProperties.shared
    @State private var addHover                 = false
    @State private var menuHover                = false
    @Binding var subMenuShown                   : Bool
    @Binding var accent                         : Color
    @Binding var cellIndex                      : Int

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                ToolbarButton(buttonAction: {self.subMenuShown.toggle()}, hover: self.$menuHover, imageName: "ellipsis", helpKey: "local_menu", accent: self.$accent, defaultBackground: Color(hex: 0x444444).opacity(0.0), hoveredBackground: !self.MSSNCGlobal.confirmDeleteNoteWindowShown ? ifYellowBG(accent: self.accent) : Color(hex: 0x444444).opacity(0.0))
                ToolbarButton(buttonAction: {self.MSSNCGlobal.duplicateNoteWindowIndex = self.cellIndex}, hover: self.$addHover, imageName: "plus", helpKey: "local_newnote", accent: self.$accent, defaultBackground: Color(hex: 0x444444).opacity(0.0), hoveredBackground: !self.MSSNCGlobal.confirmDeleteNoteWindowShown ? ifYellowBG(accent: self.accent) : Color(hex: 0x444444).opacity(0.0))
            }
            .padding(.trailing, 6).padding(.top, 1)
        }
    }
}
