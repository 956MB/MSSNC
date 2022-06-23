//
//  NoteCellPopoverView.swift
//  MSSNC
//
//  Created by Alexander Bays on 8/7/21.
//

import SwiftUI

struct NoteCellPopover: View {
    @EnvironmentObject var noteWindowProps : NoteWindowProperties
    @Binding var useAccent                 : Color
    @Binding var selectedAccent            : Color
    @State var toggled                     : Bool = false
    var openAction                         : () -> Void
    var duplicateAction                    : () -> Void
    var renameAction                       : () -> Void
    var deleteAction                       : () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                if (!self.toggled) {
                    /// open note
                    PopoverButton(buttonAction: self.openAction, imageName: self.noteWindowProps.noteOpen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right", title: self.noteWindowProps.noteOpen ? "local_closenote" : "local_opennote", frame: 11, disabled: false)
                    /// duplicate note
                    PopoverButton(buttonAction: self.duplicateAction, imageName: "doc.on.doc", title: "local_duplicatenote", frame: 11, disabled: false)
                }

                Group {
                    /// accent color toggle
                    PopoverButtonAccent(buttonAction: {self.toggleAccentDropdown()}, useDropdown: true, accent: self.$selectedAccent, dropdownToggled: self.$toggled, title: "local_accentcolor", frame: 11, disabled: false)

                    if (self.toggled) {
                        let useRed = Color(hex: NoteColors.Red.rawValue)
                        if (self.selectedAccent != useRed) {
                            PopoverButtonAccent(buttonAction: {self.updateSelectedAccent(useRed)}, useDropdown: false, accent: Binding.constant(useRed), dropdownToggled: Binding.constant(false), title: "local_accentred", frame: 11, disabled: false)
                        }
                        let useOrange = Color(hex: NoteColors.Orange.rawValue)
                        if (self.selectedAccent != useOrange) {
                            PopoverButtonAccent(buttonAction: {self.updateSelectedAccent(useOrange)}, useDropdown: false, accent: Binding.constant(useOrange), dropdownToggled: Binding.constant(false), title: "local_accentorange", frame: 11, disabled: false)
                        }
                        let useYellow = Color(hex: NoteColors.Yellow.rawValue)
                        if (self.selectedAccent != useYellow) {
                            PopoverButtonAccent(buttonAction: {self.updateSelectedAccent(useYellow)}, useDropdown: false, accent: Binding.constant(useYellow), dropdownToggled: Binding.constant(false), title: "local_accentyellow", frame: 11, disabled: false)
                        }
                        let useGreen = Color(hex: NoteColors.Green.rawValue)
                        if (self.selectedAccent != useGreen) {
                            PopoverButtonAccent(buttonAction: {self.updateSelectedAccent(useGreen)}, useDropdown: false, accent: Binding.constant(useGreen), dropdownToggled: Binding.constant(false), title: "local_accentgreen", frame: 11, disabled: false)
                        }
                        let useBlue = Color(hex: NoteColors.Blue.rawValue)
                        if (self.selectedAccent != useBlue) {
                            PopoverButtonAccent(buttonAction: {self.updateSelectedAccent(useBlue)}, useDropdown: false, accent: Binding.constant(useBlue), dropdownToggled: Binding.constant(false), title: "local_accentblue", frame: 11, disabled: false)
                        }
                        let usePurple = Color(hex: NoteColors.Purple.rawValue)
                        if (self.selectedAccent != usePurple) {
                            PopoverButtonAccent(buttonAction: {self.updateSelectedAccent(usePurple)}, useDropdown: false, accent: Binding.constant(usePurple), dropdownToggled: Binding.constant(false), title: "local_accentpurple", frame: 11, disabled: false)
                        }
                        let usePink = Color(hex: NoteColors.Pink.rawValue)
                        if (self.selectedAccent != usePink) {
                            PopoverButtonAccent(buttonAction: {self.updateSelectedAccent(usePink)}, useDropdown: false, accent: Binding.constant(usePink), dropdownToggled: Binding.constant(false), title: "local_accentpink", frame: 11, disabled: false)
                        }
                    }
                }

                if (!self.toggled) {
                    /// rename note
                    PopoverButton(buttonAction: self.renameAction, imageName: "pencil", title: "local_renamenote", frame: 11, disabled: true)
                    /// delete note
                    PopoverButton(buttonAction: self.deleteAction, imageName: "trash", title: "local_deletenote", frame: 11, disabled: false)
                }
            }
            .padding(6)
        }

    }

    func toggleAccentDropdown() {
        self.toggled.toggle()
    }
    func updateSelectedAccent(_ color: Color) {
        self.useAccent = color
        self.selectedAccent = color
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

struct PopoverButtonAccent: View {
    var buttonAction       : () -> Void
    var useDropdown        : Bool = false
    @Binding var accent    : Color
    @Binding var dropdownToggled : Bool
    var title              : String
    var frame              : CGFloat
    var disabled           : Bool
    @State var buttonHover : Bool = false

    var body: some View {
        Button(action: {
            self.buttonAction()
        }) {
            HStack(spacing: 10) {
                self.accent
                    .cornerRadius(3)
                    .frame(width: 11, height: 11, alignment: .center)

                Text(self.title.localized())
                    .lineLimit(1)
                    .foregroundColor(self.buttonHover ? Color("PopoverFGHovered") : Color("PopoverFG"))
                    .padding([.top, .bottom], 5)

                Spacer()

                if (self.useDropdown) {
                    Image(systemName: self.dropdownToggled ? "chevron.up" : "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: self.frame, height: self.frame)
                        .foregroundColor(self.buttonHover ? Color("PopoverFGHovered").opacity(0.9) : Color("PopoverFG").opacity(0.6))
                }
            }
            .padding([.leading], 8)
            .padding(.trailing, 15)
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
