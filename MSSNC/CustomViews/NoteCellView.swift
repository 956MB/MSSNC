//
//  NoteCellView.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/21/21.
//

import SwiftUI
//import MarkdownUI

struct NoteCellView: View {

    @EnvironmentObject var noteWindowProperties : NoteWindowProperties
    @StateObject var noteCells                  = NoteCells.shared
    @StateObject var MSSNCGlobal                = MSSNCGlobalProperties.shared
    @StateObject var noteCopyObject             = NoteCopyObject.shared
    @StateObject var mainWindowProperties       = MainWindowProperties.shared

    @State var fetchedNote : FetchedResults<StickyNote>.Element

    @State private var pairedNoteWindow  : NSWindow?
    @State private var cellHovered       : Bool = false
    @State private var titleHovered      : Bool = false
    @State private var cellCornerHovered : Bool = false
    @State var showAccent                : Bool = true
    @State private var isPopover         : Bool = false
    @State var newNote                   : Bool
    @State var note                      : NoteStruct
    @State var title                     : String
    @State var cellContent               : String
    @State var useAccent                 : Color
    @State var selectedAccent            : Color
    @State var cellIndex                 : Int

    /// Inits new NoteCellView
    /// - Parameters:
    ///   - fetchedNote: FetchedResults<StickyNote>.Element
    ///   - note: NoteStruct
    ///   - cellIndex: Int
    ///   - newNote: Bool
    init(fetchedNote: FetchedResults<StickyNote>.Element, note: NoteStruct, cellIndex: Int, newNote: Bool) {
        self.pairedNoteWindow = nil
        self.fetchedNote      = fetchedNote
        self.note             = note
        self.title            = note.title
        self.cellContent      = note.content
        self.useAccent        = note.accent
        self.selectedAccent   = note.accent
        self.cellIndex        = cellIndex
        self.newNote          = newNote
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 7) {
                /// accent bar
                HStack {
                    Spacer()
                }
                .frame(height: 4) // Not using changing accent height: (self.cellHovered ? 7 : 4)
                .background(RoundedCorners(tl: 4, tr: 4, bl: 0, br: 0).fill(self.showAccent ? self.useAccent.opacity(0.90) : Color("AccentDontShowCell")))

                HStack {
                    /// title
                    if (DefaultsManager.shared.useNoteTitles) {
                        Text(self.title)
                            .font(.system(size: 9))
                            .foregroundColor(Color("NoteCellDotsFG").opacity(0.50))
                    }
                    Spacer()
                    /// corner text
                    VStack(alignment: .center) {
                        Text(self.getCornerText())
                            .font((self.cellHovered || self.isPopover) ? .system(size: 14) : .system(size: 9))
                            .foregroundColor(getCornerAccentColor().opacity(0.90))
                            .padding([.trailing], 2)
                            // MARK: - padding on triple dot buttons too small, hard to click
                            .onHover {_ in
                                if (!self.MSSNCGlobal.confirmDeleteMainShown) { self.cellCornerHovered.toggle() }
                            }
                            .popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                NoteCellPopover(useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, openAction: {self.checkOpenClose()}, duplicateAction: {self.MSSNCGlobal.duplicateNoteCellIndex = self.cellIndex}, renameAction: {self.openNoteRename()}, deleteAction: {self.checkConfirmDeletePopover()})
                                    .environmentObject(self.noteWindowProperties)
                            }.buttonStyle(DefaultButtonStyle())
                    }
                    .gesture(TapGesture(count: 1).onEnded {
                        self.isPopover.toggle()
                    })
                    .padding(4)
                }
                .frame(height: 10)
                .padding(.trailing, 2)
                .padding(.leading, 15)

                /// note cell content
                VStack(alignment: .leading, spacing: 2) {
                    HStack() {
                        Text(self.cellContent)
//                        Markdown("\(self.cellContent)")
                            .lineLimit(DefaultsManager.shared.cellLineLimit)
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                            .allowsTightening(true)
                            .accentColor(ifUseAccent())

                        Spacer()
                    }
                    .padding(.leading, 15).padding(.trailing, 20)
                }
            }
            .background(RoundedCorners(tl: 4, tr: 4, bl: 0, br: 0).fill(self.cellHovered ? Color("NoteCellViewBGHovered") : Color("NoteCellViewBG")))

            /// bottom cell note edge
            HStack(spacing: 0) {
                HStack {
                    Spacer()
                }
                .frame(height: 15)
                .background(RoundedCorners(tl: 0, tr: 0, bl: 4, br: 0).fill(self.cellHovered ? Color("NoteCellViewBGHovered") : Color("NoteCellViewBG")))

                NoteEdgeRound(bgFill: self.cellHovered ? Color("NoteCellViewBGHovered") : Color("NoteCellViewBG"), fgFill: self.cellHovered ? Color("NoteEdgeBGHovered") : Color("NoteEdgeBG"))
            }
        }
        .onHover {_ in
            // MARK: - invisible part of note edge detected on hover, change
            if (!self.MSSNCGlobal.confirmDeleteMainShown) { self.cellHovered.toggle() }
        }
        .gesture(TapGesture(count: 2).onEnded {
            if (self.pairedNoteWindow != nil && self.noteWindowProperties.noteOpen) {
                self.pairedNoteWindow?.makeKeyAndOrderFront(nil)
            } else {
                self.checkOpenClose()
            }
        })


        // MARK: - WINDOW RECEIVERS
        ///
        /// OPEN/CLOSE: note opened / closed
        .onReceive(self.noteWindowProperties.$noteOpen, perform: { noteOpen in
            if (!noteOpen) {
                self.fetchedNote.open                = false
                self.MSSNCGlobal.saveCoreDataContext = true
            }
        })
        /// EDIT/SAVE: note edited
        .onReceive(self.MSSNCGlobal.$noteEdit, perform: { noteEdit in
            if ((noteEdit != -1) && (noteEdit != self.MSSNCGlobal.lastEditedNote)) {
                self.MSSNCGlobal.lastEditedNote = noteEdit
                self.noteCells.updateCellLastEdit(noteEdit)
                self.MSSNCGlobal.noteEdit = -1
            }
        })
        /// FOCUS: note gains / loses focus
        .onReceive(self.noteWindowProperties.$hasFocus, perform: { focused in
            // sets toolbar when focused, removes toolbar when not unfocused
            if (focused) {
                let customToolbar              = NSToolbar()
                self.pairedNoteWindow?.toolbar = customToolbar
                self.MSSNCGlobal.focusedNote   = self.cellIndex
            } else {
                self.pairedNoteWindow?.toolbar = .none
            }

            // saves current window pos when focus gained/lost, saves context
            if (self.pairedNoteWindow != nil) {
                self.fetchedNote.posX  = Float((self.pairedNoteWindow?.frame.minX)!)
                self.fetchedNote.posY  = Float((self.pairedNoteWindow?.frame.minY)!)
                self.fetchedNote.sizeW = Float((self.pairedNoteWindow?.frame.width)!)
                self.fetchedNote.sizeH = Float((self.pairedNoteWindow?.frame.height)!)
            }
            self.fetchedNote.content             = self.cellContent
            self.fetchedNote.lastOpened          = Date()
            self.MSSNCGlobal.saveCoreDataContext = true
        })
//        .onReceive(self.noteWindowProperties.$frame, perform: { noteFrame in
////             MARK: inefficient use of saving context with window frame, currently happens on EVERY frame update, WAYYY too many saves. need to figure out how to detect end of window move and save on that.
//
//            if (self.pairedNoteWindow != nil) {
//                self.fetchedNote.posX  = Float((self.pairedNoteWindow?.frame.minX)!)
//                self.fetchedNote.posY  = Float((self.pairedNoteWindow?.frame.minY)!)
//                self.fetchedNote.sizeW = Float((self.pairedNoteWindow?.frame.width)!)
//                self.fetchedNote.sizeH = Float((self.pairedNoteWindow?.frame.height)!)
//            }
//        })
        // MARK: - NOTE WINDOW ACTIONS
        /// CREATE: creates window for already existing note
        .onReceive(self.MSSNCGlobal.$createNewWindow, perform: { newWindow in
            if (newWindow && self.noteWindowProperties.noteOpen) {
                // MARK: BUG: multiple windows being created for note cells, (two notes = 1, 2) (three notes = 1, 2, 3) IDK
                self.pairedNoteWindow            = nil
                self.pairedNoteWindow            = newNoteWindow(noteWindowProps: self.noteWindowProperties, note: self.$note, title: self.$title, useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, noteContent: self.$cellContent, cellIndex: self.$cellIndex)
                self.newNote                     = false
                self.MSSNCGlobal.createNewWindow = false
            }
        })
        /// CREATE/DUPLICATE/COMMAND: creates new note
        .onReceive(self.MSSNCGlobal.$duplicateNewNoteCommand, perform: { duplicate in
            if (duplicate) {
                if (self.MSSNCGlobal.focusedNote != -1) {
                    self.MSSNCGlobal.duplicateNoteWindowIndex = self.cellIndex
                }
                self.MSSNCGlobal.duplicateNewNoteCommand = false
            }
        })
        /// DELETE: deletes note window matching self.cellIndex
        .onReceive(self.MSSNCGlobal.$deleteNoteWindow, perform: { delete in
            if (delete != -1 && self.cellIndex == delete) {
                if (self.pairedNoteWindow != nil && self.noteWindowProperties.noteOpen) {
                    self.pairedNoteWindow?.close()
                }
                self.MSSNCGlobal.deleteNoteCell = self.cellIndex
            }
        })
        /// DUPLICATE WINDOW: duplicates current note window matching self.cellIndex
        .onReceive(self.MSSNCGlobal.$duplicateNoteWindowIndex, perform: { duplicate in
            if (duplicate != -1 && self.cellIndex == duplicate) {
                copyNoteProperties()

                self.MSSNCGlobal.duplicateNoteWindow      = true
                self.MSSNCGlobal.duplicateNoteWindowIndex = -1
            }
        })


        // MARK: - CELL RECEIVERS
        ///
        /// SHOW ACCENT: sets note accent to grey if $useNoteAccents false, otherwise use selecedAccent
        .onReceive(DefaultsManager.shared.$useNoteAccents, perform: { showAccent in
            self.showAccent = showAccent
            self.useAccent  = self.showAccent ? self.selectedAccent : Color.gray.opacity(0.35)
        })
        /// TITLE: sets note title on change
        .onChange(of: self.title, perform: { newTitle in
            self.note.title        = newTitle
            self.fetchedNote.title = newTitle
        })
        /// CONTENT: sets note content on change
//        .onChange(of: self.cellContent, perform: { newContent in
//            self.note.content        = newContent
//            self.fetchedNote.content = newContent
//        })
        /// ACCENT: sets note accent on change
        .onChange(of: self.selectedAccent, perform: { newAccent in
            self.note.accent        = newAccent
            self.fetchedNote.accent = getFloat(newAccent)
            self.MSSNCGlobal.noteEdit = self.cellIndex
            self.MSSNCGlobal.saveCoreDataContext = true
        })
        /// DUPLICATE CELL: duplicates current note cell matching self.cellIndex
        .onReceive(self.MSSNCGlobal.$duplicateNoteCellIndex, perform: { duplicate in
            if (duplicate != -1 && self.cellIndex == duplicate) {
                copyNoteProperties()

                self.MSSNCGlobal.duplicateNoteCell      = true
                self.MSSNCGlobal.duplicateNoteCellIndex = -1
            }
        })


        // MARK: - DOCK RECEIVERS
        ///
        /// SHOW: makes note window key and brings to front on $showAllNotes change
        .onReceive(self.mainWindowProperties.$showAllNotes, perform: { showAllNotes in
            if (showAllNotes && self.pairedNoteWindow != nil && self.noteWindowProperties.noteOpen) {
                self.pairedNoteWindow?.makeKeyAndOrderFront(nil)
            }
        })
        /// HIDE: hides note window and minimizes on $hideAllNotes change
        .onReceive(self.mainWindowProperties.$hideAllNotes, perform: { hideAllNotes in
            if (hideAllNotes && self.pairedNoteWindow != nil && self.noteWindowProperties.noteOpen) {
                self.pairedNoteWindow?.miniaturize(nil)
            }
        })

        /// PAIRED WINDOW: re-creates paired note window when NoteCellView ready
        .onAppear {
            // MARK: MAYBE fixed bug of opening multiple windows for cells
            if (self.noteWindowProperties.noteOpen) {
                self.noteWindowProperties.hasFocus = false
                self.pairedNoteWindow = newNoteWindow(noteWindowProps: self.noteWindowProperties, note: self.$note, title: self.$title, useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, noteContent: self.$cellContent, cellIndex: self.$cellIndex)
            }
        }
    }

    /// opens note window if closed, closes if open, then saves context
    func checkOpenClose() {
        if (self.noteWindowProperties.noteOpen) {
            self.noteWindowProperties.noteOpen = false
            self.fetchedNote.open              = false
            if (self.pairedNoteWindow != nil) {
                self.pairedNoteWindow?.close()
            }
        } else {
            self.noteWindowProperties.noteOpen = true
            self.fetchedNote.open              = true
            self.note.open                     = true
            self.pairedNoteWindow              = nil
            self.pairedNoteWindow              = newNoteWindow(noteWindowProps: self.noteWindowProperties, note: self.$note, title: self.$title, useAccent: self.$useAccent, selectedAccent: self.$selectedAccent, noteContent: self.$cellContent, cellIndex: self.$cellIndex)
            self.MSSNCGlobal.noteEdit = self.cellIndex
        }
        self.isPopover                       = false
        self.cellCornerHovered               = false
        self.MSSNCGlobal.saveCoreDataContext = true
    }

    /// sets note for deletion if confirmBeforeDelete true, otherwise closes paired window and deletes note cell immediately
    func checkConfirmDeletePopover() {
        if (DefaultsManager.shared.confirmBeforeDelete) {
            self.MSSNCGlobal.deleteNoteTitle        = self.note.title
            self.MSSNCGlobal.confirmDeleteNoteIndex = self.cellIndex
            self.MSSNCGlobal.confirmDeleteMainShown = true
            self.isPopover                          = false
            self.cellCornerHovered                  = false
            self.cellHovered                        = false
        } else {
            if (self.pairedNoteWindow != nil && self.noteWindowProperties.noteOpen) {
                self.pairedNoteWindow?.close()
            }
            self.MSSNCGlobal.deleteNoteCell = self.cellIndex
        }
    }

    /// triggers note to be renamed either with popover in note window, or text box in note cell
    func openNoteRename() {
    }


    // MARK: - UTILS
    ///

    /// Returns Color for cell accent bar, self.selectedAccent if useNoteAccents true, otherwise gray
    /// - Returns: Color
    func ifUseAccent() -> Color {
        return DefaultsManager.shared.useNoteAccents ? self.selectedAccent.opacity(0.90) : Color.gray.opacity(0.35)
    }
    /// Copies current paired note window properties for duplicate window
    func copyNoteProperties() {
        if (self.pairedNoteWindow != nil && self.noteWindowProperties.noteOpen) {
            self.note.dimensions.posX = (self.pairedNoteWindow?.frame.minX)!
            self.note.dimensions.posY = (self.pairedNoteWindow?.frame.minY)!
            self.note.dimensions.winW = (self.pairedNoteWindow?.frame.width)!
            self.note.dimensions.winH = (self.pairedNoteWindow?.frame.height)!
        }
        self.noteCopyObject.accent  = self.note.accent
        self.noteCopyObject.content = self.note.content
        self.noteCopyObject.note    = self.note
    }
    /// Returns correct note cell corner text based on cell open, closed or hovered
    /// - Returns: String
    func getCornerText() -> String {
        if (self.cellHovered || self.isPopover) {
            return "· · ·"
        } else {
            return (self.noteWindowProperties.noteOpen) ? "local_open".localized() : formattedCornerDate(lastOpened: self.note.lastOpened)
        }
    }
    /// Returns note cell corner text color if cell hovered or not
    /// - Returns: Color
    func getCornerAccentColor() -> Color {
        if (self.cellHovered || self.isPopover) {
            return (self.cellCornerHovered) ? Color("NoteCellDotsFGHovered") : Color("NoteCellDotsFG")
        }

        return self.showAccent ? self.useAccent : Color.secondary
    }
}
