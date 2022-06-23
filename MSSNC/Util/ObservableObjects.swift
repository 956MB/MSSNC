//
//  ObservableObjects.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/28/21.
//

import SwiftUI
import AppKit

public class MSSNCGlobalProperties: ObservableObject {
    static let shared = MSSNCGlobalProperties()

    @Published var saveCoreDataContext:          Bool    = false
    @Published var confirmDeleteMainShown:       Bool    = false
    @Published var confirmDeleteNoteWindowShown: Bool    = false
    @Published var deleteNoteTitle:              String  = ""
    @Published var focusedNote:                  Int     = -1
    @Published var lastEditedNote:               Int     = -1
    @Published var noteEdit:                     Int     = -1
    @Published var createNewNoteCommand:         Bool    = false
    @Published var createNewWindow:              Bool    = false
    @Published var deleteNoteCommand:            Bool    = false
    @Published var deleteNoteWindow:             Int     = -1
    @Published var deleteNoteCell:               Int     = -1
    @Published var confirmDeleteNoteIndex:       Int     = -1
    @Published var duplicateNewNoteCommand:      Bool    = false
    @Published var duplicateNoteWindow:          Bool    = false
    @Published var duplicateNoteCell:            Bool    = false
    @Published var duplicateNoteWindowIndex:     Int     = -1
    @Published var duplicateNoteCellIndex:       Int     = -1
}
public class MainWindowProperties: ObservableObject {
    static let shared = MainWindowProperties()

    @Published var frame:                 CGRect = .zero
    @Published var focus:                 Bool   = true
    @Published var settingsOpen:          Bool   = false
    @Published var showAllNotes:          Bool   = false
    @Published var hideAllNotes:          Bool   = false
    @Published var mainWindow:            NSWindow?
    @Published var mainDockMenu:          NSMenu?
    @Published var willTerminate:         Bool   = false
    @Published var createNewNoteExternal: Bool   = false
}
public class NoteWindowProperties: ObservableObject {
    @Published var frame:           CGRect = .zero
    @Published var hasFocus:        Bool   = false
    @Published var noteOpen:        Bool   = false
    @Published var windowOpenCheck: Bool   = false
}


public class NoteCopyObject: ObservableObject {
    static let shared = NoteCopyObject()

    var title:   String     = ""
    var accent:  Color      = Color(hex: NoteColors.Yellow.rawValue)
    var content: String     = ""
    var note:    NoteStruct = NoteStruct()
}

struct NoteCell: Identifiable {
    var id:             UUID = UUID()
    var noteOpen:       Bool
    var lastEdit:       Date
    var useAccent:      Color
    var selectedAccent: Color
    var content:        String
    var cellView:       Any
}

class NoteCells: ObservableObject {
    static let shared = NoteCells(cells: [Int : NoteCell]())

    @Published var cells: [Int : NoteCell]
    @Published var cellCount: Int = 0

    init(cells: [Int : NoteCell]){
        self.cells = cells
        self.cellCount = cells.count
    }

    func setCells(_ cells: [Int : NoteCell]) {
        self.cells = cells
        self.cellCount = cells.count
    }
    func addCell(_ key: Int, _ cell: NoteCell) {
        self.cells[key] = cell
        self.cellCount += 1
    }
    func deleteCell(_ index: Int) {
        self.cells.removeValue(forKey: index)
    }
    func duplicateCell(_ index: Int) {
        self.cellCount += 1
        self.cells[self.cellCount] = self.cells[index]
    }
    func updateCellLastEdit(_ index: Int) {
        self.cells[index]?.lastEdit = Date()
    }

    func getCellsSorted() -> [NoteCell] {
        // MARK: - potential point of performance deg, sorting dict and appending to new array every list update could be bad
        // could maybe just give back already sorted array if no new note added, instead of sorting again every time and returning that
        let sortedCells = self.cells.sorted(by: { $0.value.lastEdit > $1.value.lastEdit })
        var cells: [NoteCell] = []
        for (_, value) in sortedCells {
            cells.append(value)
        }
        return cells
    }
}


public class NoteCellsTrack: ObservableObject {
    static let shared = NoteCellsTrack()

    @Published var newWindow: Bool = false
    @Published var cellsSet: Bool  = false
}
