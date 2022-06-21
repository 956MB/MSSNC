//
//  NoteTitleBar.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/25/21.
//

import SwiftUI

struct NoteTitleBar: View {

    @EnvironmentObject var noteWindowProperties : NoteWindowProperties
    @StateObject var MSSNCGlobal                = MSSNCGlobalProperties.shared
    @State private var titleHover               : Bool = false
    @State private var addHover                 : Bool = false
    @State private var isPopover                : Bool = false
    @Binding var accent                         : Color
    @Binding var subMenuShown                   : Bool
    @Binding var title                          : String
    @Binding var noteFocused                    : Bool
    @Binding var cellIndex                      : Int
//    @Binding var title                          : String

    var body: some View {
        ZStack {
            WindowRoundedToolbar(color: DefaultsManager.shared.useNoteAccents ? self.accent : Color("AccentDontShowToolbar"), height: 37)

            HStack {
                if (DefaultsManager.shared.useNoteTitles) {
                    Spacer()

                    VStack(alignment: .center) {
                        HStack(spacing: 0) {
                            /// title text
                            Text("\(self.title.truncate(length: 20))")
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(ifYellowFG(accent: self.accent))

                            /// down arrow
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .font(Font.system(size: 14, weight: .semibold))
                                .foregroundColor(((self.titleHover || self.isPopover) && !self.MSSNCGlobal.confirmDeleteNoteWindowShown) ? ifYellowFG(accent: self.accent) : Color(hex: 0xFFFFFF).opacity(0.0))
                                .padding(6)
                                .popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                    NoteTitlePopover(noteTitle: self.$title)
                                }.buttonStyle(PlainButtonStyle())
                        }
                        .frame(height: 37)
                        .opacity(!self.MSSNCGlobal.confirmDeleteNoteWindowShown ? 1 : 0.5)
                        .onHover {_ in
                            self.titleHover.toggle()
                        }
                        .gesture(TapGesture(count: 2).onEnded {
                            if (self.noteFocused && !self.MSSNCGlobal.confirmDeleteNoteWindowShown) {
                                self.isPopover.toggle()
                            }
                        })
                    }
                    .frame(height: 37)
                    .padding([.leading], 88).padding([.top], -1)
                    .disabled(!self.noteFocused)
                    .opacity(self.noteFocused ? 1 : 0)
                }

                Spacer()

                // MARK: sub menu button seems like it has a SLIGHT delay now when opening sub menu, IDK
                ToolbarButtonsStack(subMenuShown: self.$subMenuShown, accent: self.$accent, cellIndex: self.$cellIndex)
                    .environmentObject(self.noteWindowProperties)
                    .environmentObject(self.MSSNCGlobal)
                    .disabled((!self.noteFocused || self.MSSNCGlobal.confirmDeleteNoteWindowShown))
                    .opacity((self.noteFocused && !self.MSSNCGlobal.confirmDeleteNoteWindowShown) ? 1 : 0)
            }
        }
        .frame(height: 37)
    }

    func ifUseAccent() -> Color {
        if (DefaultsManager.shared.useNoteAccents) {
            return self.noteFocused ? self.accent.opacity(0.85) : self.accent.opacity(0.65)
        } else {
            return self.noteFocused ? Color.gray.opacity(0.35) : Color.gray.opacity(0.25)
        }
    }
}

struct NoteTitlePopover: View {

    @Binding var noteTitle : String
    @State var noteSecond  : String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack(spacing: 8) {
                Text("\("local_notetitle".localized()):")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                TextField("local_notetitle", text: self.$noteTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
            }
        }
        .padding(8).padding(.leading, 2)
    }
}



// This extension removes the focus ring entirely.
//extension NSTextField {
//    open override var focusRingType: NSFocusRingType {
//        get { .none }
//        set { }
//    }
//}

struct SearchTextField: View {
    @Binding var query   : String
    @State var isFocused : Bool   = false
    var placeholder      : String = "Search..."

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(Color.white)
            .frame(width: 200, height: 22)
                .overlay(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(isFocused ? Color.blue.opacity(0.7) : Color.gray.opacity(0.4), lineWidth: isFocused ? 3 : 1)
                        .frame(width: 200, height: 21)
            )

            HStack {
                Image("magnifyingglass").resizable().aspectRatio(contentMode: .fill)
                    .frame(width:12, height: 12)
                    .padding(.leading, 5)
                    .opacity(0.8)
                TextField(placeholder, text: $query, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        self.isFocused = true
                    } else {
                        self.isFocused = false
                    }
                })
                    .textFieldStyle(PlainTextFieldStyle())
                if query != "" {
                    Button(action: {
                            self.query = ""
                    }) {
                        Image("xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:14, height: 14)
                            .padding(.trailing, 3)
                            .opacity(0.5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(self.query == "" ? 0 : 0.5)
                }
            }

        }
    }
}
