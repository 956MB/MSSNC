//
//  NoteAccentSelector.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/23/21.
//

import SwiftUI

struct NoteAccentSelector: View {
    @StateObject var MSSNCGlobal = MSSNCGlobalProperties.shared
    @Binding var useAccent       : Color
    @Binding var selectedAccent  : Color
    @Binding var subMenuShown    : Bool

    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: 0) {
                AccentButtonView(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown, accentId: Color(hex: NoteColors.Red.rawValue), accentKey: "local_accentred", _tl: 7, _bl: 7)
                AccentButtonView(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown, accentId: Color(hex: NoteColors.Orange.rawValue), accentKey: "local_accentorange")
                AccentButtonView(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown, accentId: Color(hex: NoteColors.Yellow.rawValue), accentKey: "local_accentyellow")
                AccentButtonView(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown, accentId: Color(hex: NoteColors.Green.rawValue), accentKey: "local_accentgreen")
                AccentButtonView(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown, accentId: Color(hex: NoteColors.Blue.rawValue), accentKey: "local_accentblue")
                AccentButtonView(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown, accentId: Color(hex: NoteColors.Purple.rawValue), accentKey: "local_accentpurple")
                AccentButtonView(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown, accentId: Color(hex: NoteColors.Pink.rawValue), accentKey: "local_accentpink", _tr: 7, _br: 7)
            }
        }
        .frame(minWidth: 0, maxWidth: 363)
        .background(RoundedCorners(tl: 7, tr: 7, bl: 7, br: 7).fill(Color("SubMenuButtonContainerBG")))
        .padding([.leading, .trailing], 9)
        .padding(.top, 46)
    }
}

struct AccentButtonView: View {
    @StateObject var MSSNCGlobal   = MSSNCGlobalProperties.shared
    @Binding var useAccent         : Color
    @Binding var selectedAccent    : Color
    @Binding var subMenuShown      : Bool
    @State var accentButtonHovered : Bool = false
    var accentId                   : Color
    var accentKey                  : String

    var _tl: CGFloat = 0
    var _tr: CGFloat = 0
    var _bl: CGFloat = 0
    var _br: CGFloat = 0

    var body: some View {
        Button(action: {
            if (DefaultsManager.shared.useNoteAccents) {
                self.useAccent = accentId
            }
            self.selectedAccent = accentId
            self.subMenuShown.toggle()
        }) {
            /// checkmark overlay
            self.accentId
                .overlay(
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 13, height: self.accentButtonHovered ? 17 : 13)
                        .foregroundColor(self.selectedAccent == self.accentId ? ifYellowFG(accent: self.selectedAccent) : Color.clear)
                )
                .clipShape(RoundedCorners(tl: _tl, tr: _tr, bl: _bl, br: _br))
                .frame(minWidth: 0, minHeight: 37, maxHeight: 37)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover {_ in self.accentButtonHovered.toggle()}
        .help(self.accentKey.localized())
    }
}
