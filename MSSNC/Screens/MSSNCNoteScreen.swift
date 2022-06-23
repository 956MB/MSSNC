//
//  MSSNCNoteScreen.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/21/21.
//

import SwiftUI
//import MarkdownUI

struct MSSNCNoteScreen: View {

    @EnvironmentObject var noteWindowProperties: NoteWindowProperties
    @StateObject var MSSNCGlobal               = MSSNCGlobalProperties.shared
    let def                                    = DefaultsManager.shared
    @State var subMenuShown                    : Bool    = false
    @State var noteFocused                     : Bool    = false
    @State var fontSize                        : CGFloat = 14
    @State var lastEditText                    : String  = ""
    @Binding var note                          : NoteStruct
    @Binding var title                         : String
    @Binding var useAccent                     : Color
    @Binding var selectedAccent                : Color
    @Binding var noteContent                   : String
    @Binding var cellIndex                     : Int

    var body: some View {
        ZStack {
            VStack {
                /// Note last edited text
                if (self.noteFocused) {
                    VStack(alignment: .center) {
                        Text(self.lastEditText)
                            .font(.system(size: 11))
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(Color.secondary.opacity(0.7))
                            .opacity(self.subMenuShown ? 0.4 : 1.0)
                    }
                }

                Color.clear
                    /// not editable note content text
                    .overlay(
                        (self.subMenuShown || self.MSSNCGlobal.confirmDeleteNoteWindowShown) ?

                        Text(self.note.content)
                            .font(.system(size: self.fontSize))
                            .opacity(self.subMenuShown ? 0.4 : 1.0)
                            .padding([.leading, .trailing], 15).padding(.bottom, 15)

                        : nil, alignment: .topLeading
                    )
                    /// editable note content TextEditor
                    .overlay(
                        (self.subMenuShown || self.MSSNCGlobal.confirmDeleteNoteWindowShown) ? nil :
//                        NoteTextEditorView(noteContent: self.$noteContent, subMenuShown: self.$subMenuShown)
                        TextEditor(text: self.$noteContent)
                            .font(.system(size: self.fontSize))
                            .opacity(self.subMenuShown ? 0.4 : 1.0)
                            .padding([.leading, .trailing], 10).padding(.bottom, 15)
                            .onChange(of: self.noteContent, perform: { _ in
                                if (self.note.open) {
                                    self.MSSNCGlobal.noteEdit = self.cellIndex
                                }
                            })
                    )
            }
            .padding(.top, 48)

            /// Note submenu (accent selector, buttons)
            VStack(spacing: 0) {
                if (noteWindowProperties.frame.size.width >= 250 && self.noteFocused) {
                    if (self.subMenuShown) {
                        HStack {
                            VStack {
                                /// accent color selector
                                if (self.def.useNoteAccents) {
                                    NoteAccentSelector(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, subMenuShown: self.$subMenuShown)
                                        .environmentObject(self.MSSNCGlobal)
                                }
                                /// notes list and delete note
                                NoteSubMenu(subMenuShown: self.$subMenuShown, cellIndex: self.$cellIndex, listAction: {showListWindowAndCloseSubMenu()}, deleteAction:{self.checkConfirmDeleteSubMenu()})
                                    .environmentObject(self.noteWindowProperties)
                            }
                            .frame(maxWidth: 363, alignment: .trailing)
                            .cornerRadius(7)
                            .background(RoundedCorners(tl: 7, tr: 7, bl: 7, br: 7).fill(Color(hex: 0x1B1B1B)))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 15) // 48

                        HStack {
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedCorners(tl: 7, tr: 7, bl: 7, br: 7).fill(Color(hex: 0xFFFFFF).opacity(0.001)))
                        .gesture(TapGesture(count: 1).onEnded {
                            self.subMenuShown = false
                        })
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)

            // MARK: currently no purpose for edit bar
            /// note edit bar
//            VStack() {
//                if (noteWindowProperties.frame.size.width >= 272 && self.noteFocused) {
//                    Spacer()
//
//                    NoteEditBar(subMenuShown: self.$subMenuShown, boldHovered: self.$boldHovered, italicsHovered: self.$italicsHovered, underlineHovered: self.$underlineHovered, strikethroughHovered: self.$strikethroughHovered, bulletsHovered: self.$bulletsHovered, imageHovered: self.$imageHovered, boldToggled: self.$boldToggled, italicsToggled: self.$italicsToggled, underlineToggled: self.$underlineToggled, strikethroughToggled: self.$strikethroughToggled, bulletsToggled: self.$bulletsToggled, imageToggled: self.$imageToggled)
//                }
//            }
//            .frame(maxHeight: .infinity)

            /// confirm before delete view
            if (self.MSSNCGlobal.confirmDeleteNoteWindowShown && self.MSSNCGlobal.confirmDeleteNoteIndex == self.cellIndex) {
                ConfirmBeforeDeleteDialog()
                    .padding([.top], 28)
            }

            /// title bar
            VStack() {
                NoteTitleBar(accent: self.$useAccent, subMenuShown: self.$subMenuShown, title: self.$title, noteFocused: self.$noteFocused, cellIndex: self.$cellIndex)
                    .environmentObject(self.noteWindowProperties)
                    .environmentObject(self.MSSNCGlobal)
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .frame(minWidth: 260, maxWidth: .infinity, minHeight: 260, maxHeight: .infinity)
        .padding(.top, -37)
//        .background(VisualEffectBackground(material: NSVisualEffectView.Material.menu, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))

        
        /// RECEIVERS
        ///
        /// FOCUS: closes submenu if note loses focus
        .onReceive(self.noteWindowProperties.$focus, perform: { focused in
            if (self.noteFocused && !focused && self.subMenuShown) {
                self.subMenuShown = false
            }
            self.noteFocused = focused
        })
        /// FONT: updates used font size
        .onReceive(self.def.$fontSize, perform: { fontSize in
            self.fontSize = CGFloat(fontSize)
        })
        /// EDIT: updates last edit text
        .onReceive(self.note.$lastOpened, perform: { _ in
            self.lastEditText = getLastEditText()
        })
        /// DELETE/COMMAND: deletes current open note from command/shortcut
        .onReceive(self.MSSNCGlobal.$deleteNoteCommand, perform: { delete in
            if (delete) {
                if (self.cellIndex == self.MSSNCGlobal.focusedNote) {
                    self.checkConfirmDeleteSubMenu()
                }
                self.MSSNCGlobal.deleteNoteCommand = false
            }
        })

        // MARK: binding being attached to note accent instead of seperate accent var makes things not update immediately, BUG
//        .onReceive(DefaultsManager.shared.$useNoteAccents, perform: { showAccent in
////            self.showAccent = showAccent
////            self.useAccent  = self.showAccent ? self.selectedAccent : Color.gray.opacity(0.35)
////            self.note.accent = self.note.accent
//        })
    }

    /// Returns formatted last edit text for open note
    /// - Returns: String
    func getLastEditText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: self.note.lastOpened)
    }

    /// Checks if confirm before delete true, deletes note otherwise
    func checkConfirmDeleteSubMenu() {
        self.subMenuShown = false

        if (DefaultsManager.shared.confirmBeforeDelete) {
            self.MSSNCGlobal.deleteNoteTitle              = self.note.title
            self.MSSNCGlobal.confirmDeleteNoteIndex       = self.cellIndex
            self.MSSNCGlobal.confirmDeleteNoteWindowShown = true
        } else {
            self.MSSNCGlobal.deleteNoteWindow = self.cellIndex
        }
    }

    /// Closes sub menu and shows main window notes list
    public func showListWindowAndCloseSubMenu() {
        self.subMenuShown.toggle()
        MainWindowProperties.shared.mainWindow?.makeKeyAndOrderFront(nil)
    }
}
