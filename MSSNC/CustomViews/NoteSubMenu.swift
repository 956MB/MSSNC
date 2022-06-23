//
//  NoteSubMenu.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/24/21.
//

import SwiftUI

struct NoteSubMenu: View {

    @EnvironmentObject var noteWindowProperties: NoteWindowProperties
    @StateObject var MSSNCGlobal = MSSNCGlobalProperties.shared
    let def                      = DefaultsManager.shared
    @Binding var subMenuShown    : Bool
    @Binding var cellIndex       : Int

    var listAction:   () -> Void
    var deleteAction: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: 8) {
                SubMenuButton(buttonAction: {self.listAction()}, subMenuShown: self.$subMenuShown, buttonImage: "text.alignleft", buttonText: (noteWindowProperties.frame.size.width <= 300 && self.noteWindowProperties.noteOpen) ? "local_noteslistshort".localized() : "local_noteslist".localized(), buttonHelp: "local_noteslist".localized())
                SubMenuButton(buttonAction: {self.deleteAction()}, subMenuShown: self.$subMenuShown, buttonImage: "trash", buttonText: (noteWindowProperties.frame.size.width <= 300 && self.noteWindowProperties.noteOpen) ? "local_deletenoteshort".localized() : "local_deletenote".localized(), buttonHelp: "local_deletenote".localized())
            }
            .padding(8)
        }
        .frame(minWidth: 0, maxWidth: 363)
        .background(RoundedCorners(tl: 7, tr: 7, bl: 7, br: 7).fill(Color("SubMenuButtonContainerBG")))
        .padding([.leading, .trailing], 9)
        .padding([.bottom], 8)
        .padding([.top], self.def.useNoteAccents ? 0 : 48)
    }
}

struct SubMenuButton: View {
    var buttonAction: () -> Void

    @Binding var subMenuShown    : Bool
    @State var menuButtonHovered : Bool = false
    var buttonImage              : String
    var buttonText               : String
    var buttonHelp               : String

    var body: some View {
        Button(action: {
            self.buttonAction()
        }) {
            HStack {
                Spacer()
                HStack(alignment: .center, spacing: 11) {
                    Image(systemName: self.buttonImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 11, height: 11)
                        .foregroundColor(self.menuButtonHovered ? Color("PopoverFGHovered") : Color("PopoverFG"))
                    Text(self.buttonText)
                        .foregroundColor(self.menuButtonHovered ? Color("PopoverFGHovered") : Color("PopoverFG"))
                }
                Spacer()
            }
            .frame(minWidth: 11, minHeight: 11, maxHeight: 11)
            .padding(6).padding([.top, .bottom], 3)
            .contentShape(RoundedRectangle(cornerSize: CGSize(width: 7, height: 7)))
        }
        .buttonStyle(PlainButtonStyle())
        .background(self.menuButtonHovered ? Color("SubMenuButtonBGHovered") : Color("SubMenuButtonBG"))
        .onHover {_ in self.menuButtonHovered.toggle()}
        .cornerRadius(7)
        .help(self.buttonHelp)
    }
}
