//
//  NoteCellPopoverView.swift
//  MSSNC
//
//  Created by Trevor Bays on 8/7/21.
//

import SwiftUI

struct NoteCellPopover: View {
    @EnvironmentObject var noteWindowProps : NoteWindowProperties
    var openAction                         : () -> Void
    var duplicateAction                    : () -> Void
    var renameAction                       : () -> Void
    var deleteAction                       : () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            /// open note
            PopoverButton(buttonAction: self.openAction, imageName: self.noteWindowProps.noteOpen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right", title: self.noteWindowProps.noteOpen ? "local_closenote" : "local_opennote", frame: 11, disabled: false)
            /// duplicate note
            PopoverButton(buttonAction: self.duplicateAction, imageName: "doc.on.doc", title: "local_duplicatenote", frame: 11, disabled: false)
            /// rename note
            PopoverButton(buttonAction: self.renameAction, imageName: "pencil", title: "local_renamenote", frame: 11, disabled: true)
            /// delete note
            PopoverButton(buttonAction: self.deleteAction, imageName: "trash", title: "local_deletenote", frame: 11, disabled: false)
        }
        .padding(6)
    }
}

struct PopoverButton: View {
    var buttonAction       : () -> Void
    var imageName          : String
    var title              : String
    var frame              : CGFloat
    var disabled           : Bool
    @State var buttonHover : Bool = false

    var body: some View {
        Button(action: {
            self.buttonAction()
        }) {
            HStack(spacing: 10) {
                Image(systemName: self.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.frame, height: self.frame)
                    .foregroundColor(self.buttonHover ? Color("PopoverFGHovered").opacity(0.9) : Color("PopoverFG").opacity(0.6))
                Text(self.title.localized())
                    .lineLimit(1)
                    .foregroundColor(self.buttonHover ? Color("PopoverFGHovered") : Color("PopoverFG"))
                    .padding([.top, .bottom], 5)
                Spacer()
            }
            .padding(.leading, 8)
            .contentShape(RoundedRectangle(cornerSize: CGSize(width: 3, height: 3)))
        }
        .padding(.trailing, -8)
        .buttonStyle(PlainButtonStyle())
        .onHover {_ in
            if (!self.disabled) {
                self.buttonHover.toggle()
            }
        }
        .background(RoundedCorners(tl: 5, tr: 5, bl: 5, br: 5).fill(self.buttonHover ? Color("PopoverBGHovered") : Color.clear))
        .disabled(self.disabled)
    }
}
