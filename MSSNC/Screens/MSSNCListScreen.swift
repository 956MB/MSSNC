//
//  MSSNCListScreen.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/19/21.
//

import SwiftUI
//import MarkdownUI

struct MSSNCListScreen: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [])
    private var stickyNotes : FetchedResults<StickyNote>

    @StateObject var def                   = DefaultsManager.shared
    @StateObject var noteCellsTrack        = NoteCellsTrack()
    @StateObject var noteCells             = NoteCells.shared
    @StateObject var MSSNCGlobal           = MSSNCGlobalProperties.shared
    @StateObject var mainWindowProperties  = MainWindowProperties.shared
    @StateObject var noteCopyObject        = NoteCopyObject.shared

    @State private var settingsHover : Bool = false
    @State private var addHover      : Bool = false
    @State private var windowFocused : Bool = true

//    init() {
//        // used for testing
//        PersistenceController.shared.clearAllStickyNotes()
//    }

    var body: some View {
        Execute {
            if (!self.noteCellsTrack.cellsSet) {
                self.initializeNoteCells()
                self.noteCellsTrack.cellsSet = true
            }
        }
        MSSNCWindowRegular(color: Color("ToolbarBGFocused"), content: {
            VStack {
                ZStack {
                    /// settings view
                    MSSNCSettingsScreen()
                        .disabled(!self.mainWindowProperties.settingsOpen)
                        .opacity(self.mainWindowProperties.settingsOpen ? 1 : 0)

                    /// notes cells
                    ScrollView {
                            ForEach(self.noteCells.getCellsSorted()) { cell in
                                AnyView(_fromValue: cell.cellView)
                                    .padding([.leading, .trailing], 10)
                                    .padding([.bottom], 2)
                            }
                    }
                    .padding(.top, 48)
                    .disabled(self.mainWindowProperties.settingsOpen)
                    .opacity(self.mainWindowProperties.settingsOpen ? 0 : 1)

                    /// confirm before delete dialog
                    if (self.MSSNCGlobal.confirmDeleteMainShown) {
                        ConfirmBeforeDeleteDialog()
                    }
                }
            }
        }).toolbarContent(toolbar: {
            ZStack {
                /// sticky notes / settings title
                HStack {
                    Spacer()
                    Text(self.mainWindowProperties.settingsOpen ? "local_settingstitle".localized() : "local_stickynotestitle".localized())
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(Color.primary.opacity(0.95))
                        .opacity(!self.MSSNCGlobal.confirmDeleteMainShown ? 1 : 0.5)
                    Spacer()
                }
                HStack(alignment: .center) {
                    Spacer()

                    /// settings gear button
                    // MARK: temporarily removed settings button, can be triggered with keybind or command menu
//                    if (!self.mainWindowProperties.settingsOpen) {
//                        Button(action: {
//                            self.mainWindowProperties.settingsOpen.toggle()
//                        }) {
//                            ButtonImage(hovered: self.$settingsHover, imageSystemName: self.mainWindowProperties.settingsOpen ? "gearshape" : "gearshape", defaultFontColor: Color.primary.opacity(0.65), hoveredFontColor: Color(hex: 0x9b9b9b), fontSize: 15, imageRotation: self.mainWindowProperties.settingsOpen ? 45 : 0)
//                                .help(self.mainWindowProperties.settingsOpen ? "local_settingstitle".localized() : "local_settingstitle".localized())
//                        }
//                        .modifier(RoundedButtonModifier(defaultBackground: Color.clear, hoveredBackground: (!self.MSSNCGlobal.confirmDeleteMainShown) ? Color("ToolbarButtonBGHovered") : Color(hex: 0x444444).opacity(0.0)))
//                    }

                    /// new note / settings close button
                    Button(action: {
                        if (self.mainWindowProperties.settingsOpen) {
                            self.mainWindowProperties.settingsOpen.toggle()
                        } else {
                            self.MSSNCGlobal.createNewNoteCommand = true
                        }
                    }) {
                        ButtonImage(hovered: self.$settingsHover, imageSystemName: self.mainWindowProperties.settingsOpen ? "chevron.left" : "plus", defaultFontColor: Color.primary.opacity(0.65), hoveredFontColor: Color(hex: 0x9b9b9b), fontSize: self.mainWindowProperties.settingsOpen ? 14 : 14, imageRotation: self.mainWindowProperties.settingsOpen ? 0 : 0)
                            .help(self.mainWindowProperties.settingsOpen ? "local_back".localized() : "local_newnote".localized())
                    }
                    .modifier(RoundedButtonModifier(defaultBackground: Color.clear, hoveredBackground: (!self.MSSNCGlobal.confirmDeleteMainShown) ? Color("ToolbarButtonBGHovered") : Color(hex: 0x444444).opacity(0.0)))
                    .padding([.leading], 5)
                }
                .frame(height: 37)
                .padding([.trailing], 6)
            }
            // MARK: temporarily removing these modifiers to counteract the opposite effects of the window focus bug, fix later
            .disabled((!self.windowFocused || self.MSSNCGlobal.confirmDeleteMainShown))
            .opacity((!self.windowFocused || self.MSSNCGlobal.confirmDeleteMainShown) ? 0.35 : 1.0)
        })
        .frame(minWidth: 255, idealWidth: 550, minHeight: 335, idealHeight: 500)
        .padding(.top, -37)
        .toolbar(content: {
            HStack {
                Spacer()
            }
        })


        // MARK: RECEIVERS
        ///
        /// SAVE/CONTEXT: saves current CoreData context
        .onReceive(self.MSSNCGlobal.$saveCoreDataContext, perform: { saveContext in
            if (saveContext) {
                PersistenceController.shared.saveContext(context: self.viewContext)
                self.MSSNCGlobal.saveCoreDataContext = false
            }
        })
        /// FOCUS: sets main window focus
        .onReceive(self.mainWindowProperties.$focus, perform: { focused in
            self.windowFocused = focused
            self.MSSNCGlobal.focusedNote = -1
        })
        /// CREATE/DOCK: creates new note from dock
        .onReceive(self.mainWindowProperties.$createNewNoteExternal, perform: { create in
            if (create) {
                let newStickyNote = PersistenceController.shared.addStickyNote(context: self.viewContext, save: true, originWindow: self.mainWindowProperties.frame)
                createNote(createdStickyNote: newStickyNote)
                self.mainWindowProperties.createNewNoteExternal = false
            }
        })
        /// CREATE/COMMAND: creates new note from command
        .onReceive(self.MSSNCGlobal.$createNewNoteCommand, perform: { create in
            if (create) {
                let newStickyNote = PersistenceController.shared.addStickyNote(context: self.viewContext, save: true, originWindow: self.mainWindowProperties.frame)
                createNote(createdStickyNote: newStickyNote)
                self.MSSNCGlobal.createNewNoteCommand = false
            }
        })
        /// DELETE: deletes note cell with supplied cellIndex
        .onReceive(self.MSSNCGlobal.$deleteNoteCell, perform: { deleteCellIndex in
            if (deleteCellIndex != -1) {
                self.MSSNCGlobal.deleteNoteCell         = -1
                self.MSSNCGlobal.deleteNoteWindow       = -1
                self.MSSNCGlobal.confirmDeleteNoteIndex = -1

//                print("before delete cell: ", deleteCellIndex, self.noteCells.cellCount, Array(self.noteCells.cells.keys))
                let stickyNoteDel = self.stickyNotes[deleteCellIndex]
                self.noteCells.deleteCell(deleteCellIndex)
                self.viewContext.delete(stickyNoteDel)
                self.MSSNCGlobal.saveCoreDataContext = true
            }
        })
        /// DUPLICATE: duplicates note window with supplied cellIndex
        .onReceive(self.MSSNCGlobal.$duplicateNoteWindow, perform: { duplicateWindow in
            if (duplicateWindow) {
                self.duplicateNote(createWindow: true)
                self.MSSNCGlobal.duplicateNoteWindow = false
            }
        })
        /// DUPLICATE: duplicates note cell with supplied cellIndex
        .onReceive(self.MSSNCGlobal.$duplicateNoteCell, perform: { duplicateCell in
            if (duplicateCell) {
                self.duplicateNote(createWindow: false)
                self.MSSNCGlobal.duplicateNoteCell = false
            }
        })
    }

    /// Creates new note
    /// - Parameter createdStickyNote: supplied StickyNote
    func createNote(createdStickyNote: StickyNote) {
        let newIndex = self.noteCells.cellCount + 1
        createNoteObject(index: newIndex, fetchedNote: createdStickyNote)
    }

    func duplicateNote(createWindow: Bool) {
        let copyNote = self.noteCopyObject.note

        let duplicateNote = PersistenceController.shared.duplicateStickyNote(context: self.viewContext, title: copyNote.title, open: createWindow, accent: getFloat(self.noteCopyObject.accent), content: copyNote.content, posX: Float(copyNote.dimensions.posX) + (Float(copyNote.dimensions.winW)+8), posY: Float(copyNote.dimensions.posY), sizeW: Float(copyNote.dimensions.winW), sizeH: Float(copyNote.dimensions.winH), save: true)
        createNote(createdStickyNote: duplicateNote)
    }

    /// Initializes save CoreData notes into note cells
    func initializeNoteCells() {
        for (index, fetchedNote) in self.stickyNotes.enumerated() {
            createNoteObject(index: index, fetchedNote: fetchedNote)
        }
    }

    /// Creates note object from supplied index and fetched CoreData StickyNote
    /// - Parameters:
    ///   - index: Int
    ///   - fetchedNote: StickyNote
    func createNoteObject(index: Int, fetchedNote: StickyNote) {
        let winProps      = NoteWindowProperties()
        winProps.noteOpen = fetchedNote.open
        winProps.hasFocus    = false
        winProps.frame    = CGRect(x: fetchedNote.posX.hashValue, y: fetchedNote.posY.hashValue, width: fetchedNote.sizeW.hashValue, height: fetchedNote.sizeH.hashValue)

        let noteStruct             = NoteStruct()
        noteStruct.title           = fetchedNote.title ?? "local_untitlednote".localized()
        noteStruct.lastOpened      = fetchedNote.lastOpened ?? Date()
        noteStruct.open            = fetchedNote.open
        noteStruct.accent          = Color(hex: getHex(fetchedNote.accent).rawValue)
        noteStruct.dimensions.posX = CGFloat(fetchedNote.posX)
        noteStruct.dimensions.posY = CGFloat(fetchedNote.posY)
        noteStruct.dimensions.winW = CGFloat(fetchedNote.sizeW)
        noteStruct.dimensions.winH = CGFloat(fetchedNote.sizeH)
        noteStruct.content         = fetchedNote.content ?? ""

        let noteCellView = NoteCellView(fetchedNote: fetchedNote, note: noteStruct, cellIndex: index, newNote: false).environmentObject(winProps)
        let noteCell     = NoteCell(noteOpen: fetchedNote.open, lastEdit: noteStruct.lastOpened, useAccent: Color(hex: getHex(fetchedNote.accent).rawValue), selectedAccent: Color(hex: getHex(fetchedNote.accent).rawValue), content: fetchedNote.content ?? "", cellView: noteCellView)

        self.noteCells.addCell(index, noteCell)
    }
}
