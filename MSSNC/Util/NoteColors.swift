//
//  NoteColors.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/21/21.
//

import SwiftUI

enum NoteColors: UInt, Codable {
    case Red    = 0xff002e
    case Orange = 0xff8a00
    case Yellow = 0xffd732
    case Green  = 0x15a73d
    case Blue   = 0x2c64cf
    case Purple = 0x912ccf
    case Pink   = 0xe54fdf
    case Grey   = 0x636363

}

func getHex(_ float: Float) -> NoteColors {
    switch(float) {
    case 0:  return NoteColors.Red
    case 1:  return NoteColors.Orange
    case 2:  return NoteColors.Yellow
    case 3:  return NoteColors.Green
    case 4:  return NoteColors.Blue
    case 5:  return NoteColors.Purple
    case 6:  return NoteColors.Pink
    default: return NoteColors.Yellow
    }
}

func getFloat(_ hex: Color) -> Float {
    if (hex == Color(hex: NoteColors.Red.rawValue)) {
        return 0
    } else if (hex == Color(hex: NoteColors.Orange.rawValue)) {
        return 1
    } else if (hex == Color(hex: NoteColors.Yellow.rawValue)) {
        return 2
    } else if (hex == Color(hex: NoteColors.Green.rawValue)) {
        return 3
    } else if (hex == Color(hex: NoteColors.Blue.rawValue)) {
        return 4
    } else if (hex == Color(hex: NoteColors.Purple.rawValue)) {
        return 5
    } else if (hex == Color(hex: NoteColors.Pink.rawValue)) {
        return 6
    } else {
        return 2
    }
}

func ifYellowFG(accent: Color) -> Color {
    if ((accent == Color(hex: NoteColors.Red.rawValue) || accent == Color(hex: NoteColors.Orange.rawValue) || accent == Color(hex: NoteColors.Yellow.rawValue)) && DefaultsManager.shared.useNoteAccents) {
//        return Color(hex: 0x000000).opacity(0.70)
//        return Color.primary.opacity(0.70)
        return (Color("ToolbarButtonAccentFGDark"))
    } else {
//        return Color(hex: 0xFFFFFF).opacity(0.80)
        return Color.primary.opacity(0.65)
//        return (Color("ToolbarButtonAccentFG"))
    }
}

func ifYellowBG(accent: Color) -> Color {
    if (accent == Color(hex: NoteColors.Red.rawValue) && DefaultsManager.shared.useNoteAccents) {
        return Color(hex: 0x000000).opacity(0.17)
    } else if ((accent == Color(hex: NoteColors.Orange.rawValue) || accent == Color(hex: NoteColors.Yellow.rawValue)) && DefaultsManager.shared.useNoteAccents) {
        return Color(hex: 0x000000).opacity(0.09)
    } else {
//        return Color(hex: 0xFFFFFF).opacity(0.10)
        return Color("ToolbarButtonBGHovered")
    }
}
