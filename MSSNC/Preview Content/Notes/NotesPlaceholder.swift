//
//  NotesPlaceholder.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/21/21.
//

//import MarkdownUI
import SwiftUI

//NOTES FOR STICKY NOTES CLONE
//
// [ ] able to collapse all notes in sticky notes main window, so therye smaller
// [ ] setting to control how many lines are previewed in sticky notes main window
// [X] more colors
// [X] ctrl + - / ctrl+ + for note font size
// [ ] monospace font settings
// [X] when main window is too wide, large space to the rioght of scrollbar and the notes dont expand over all the way
// [X] auto save on/off setting
// [X] show which notes are open in the main window under its note cell
// [ ] move last opened note to top of list when closed/reopened
// [ ] option to present open notes in a window manager type organized manner, then return to normal if turned off or layout changed... different layouts like stacked, grid etfc,,,,,
// [X] be able to name notes, maybe give them metadata too, name could show up on topbar in between plus button on left and three dots and x on rright
// [ ] ^^^ notes categories, like icloud notes
// [X] setting to always open main/settings window on start
// [X] redesign light mode, current light mode on sticky notes looks like SHIT
// [ ] able to copy markdown formatting of note, unlike window sticky notes
// [ ] export all notes option. exports all mssnc notes to json or something as backup, you can import this json file also
//      ^^^ importing josn also check the notes to see if any are copies, then maybe asks if you want to import these anyway
//      ^^^ option asks you if you want to export as full MSSNC json file, or seperate .txt/md files.
//      ^^^ ticker option when exporting if you want .txt files or .md
//
// [X] dock icon options: new note, notes list, settings, show all notes, hide all notes
// [ ] stay on top toggle for all/single windows
// [ ] toggle to disable translucent windows
// [X] "duplicate note" option in cell popover
// [X] tap to dismiss gestures on submenu and confirm delete dialog
// [ ] undo/redo system
// [X] if note already open, double click on cell or open action in popover focuses that note window
// [X] default accent picker settingg
// [X] confirm before deleting dialog
// [B] (bugs, come back) universal or individual font size setting, font increase/decrease either applies to single windows, or all at once

//let defaultEmptyNote = Note(title: "local_untitlednote".localized(), lastOpened: "", accentColor: Color(hex: NoteColors.Yellow.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 300, winH: 500), content: "")

func defaultEmptyNote() -> NoteStruct {
    let defNote = NoteStruct()
    defNote.dimensions.posX = 957
    defNote.dimensions.posY = 220
    return defNote
//    return NoteStruct(title: "local_untitlednote".localized(), lastOpened: newDateTimeString(), accentColor: Color(hex: NoteColors.Yellow.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 300, winH: 500), content: "")
}

let n1 = NoteStruct(title: "??? - da - \"dah\"", lastOpened: Date(), accent: Color(hex: NoteColors.Yellow.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 350, winH: 600), content: d1)
let n2 = NoteStruct(title: "?????? - \"ah-e\" - child", lastOpened: Date(), accent: Color(hex: NoteColors.Yellow.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 350, winH: 600), content: d2)
let n3 = NoteStruct(title: "??? - a - \"ah\"        ??? - wa - \"wah\"", lastOpened: Date(), accent: Color(hex: NoteColors.Green.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 350, winH: 600), content: d3)
let n4 = NoteStruct(title: "??? - \"ku\"             ??? - \"jtsu\"", lastOpened: Date(), accent: Color(hex: NoteColors.Yellow.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 350, winH: 600), content: d4)
let n5 = NoteStruct(title: "??? - da - \"dah\"", lastOpened: Date(), accent: Color(hex: NoteColors.Red.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 350, winH: 600), content: d5)
let n6 = NoteStruct(title: "??? - da - \"dah\"", lastOpened: Date(), accent: Color(hex: NoteColors.Blue.rawValue), dimensions: NoteWindow(posX: 957, posY: 220, winW: 350, winH: 600), content: d6)

let d1 = """
    **??? - da - \"dah\"**
    **??? - do - \"doh\"**
    **??? - ttwa - \"ttwah\"**
    **??? - tto - \"tto\"**
    """

let d2 = """
    **?????? - "ah-e" - child**
    **??? - "e" - this, these**
    **?????? - "oo-you" - milk**
    **??? - "yeh" - yes**
    **?????? - "u-weh" - friendship, raincoat**
    """

let d3 = """
    **??? - a - "ah"        ??? - wa - "wah"**
    **??? - eo - "aw"      ??? - wo - "woh"**
    **??? - o - "oo"        ??? - ui - "we"**
    **??? - i - "e"            ??? - oe - "weh"**
    **??? - u - "ouh"      ??? - wae - "weh"**

    """

let d4 = """
    **??? - "ku"             ??? - "jtsu"**
    **??? - "gu"             ??? - "chu"**
    **??? - "nu"             ??? - "ku"**
    **??? - "tu"              ??? - "te"**
    **??? - "du"             ??? - "pe"**
    """

let d5 = """
    **??? - da - "dah"**
    **??? - do - "doh"**
    **??? - ttwa - "ttwah"**
    **??? - tto - "tto"**
    """

let d6 = """
    **??? - da - \"dah\"**
    **??? - do - \"doh\"**
    **??? - ttwa - \"ttwah\"**
    **??? - tto - \"tto\"**
    """
