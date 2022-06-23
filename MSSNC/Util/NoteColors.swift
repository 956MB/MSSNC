//
//  NoteColors.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/21/21.
//

import SwiftUI

/// Available note colors hex values
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

/// Returns NoteColor (NoteColor, Hex) from supplied float (Float)
/// - Parameter float: NoteColor as float (Float)
/// - Returns: NoteColor hex code (NoteColor)
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

/// Returns float version of NoteColor from supplied color (Color)
/// - Parameter hex: NoteColor (Color)
/// - Returns: NoteColor as float (Float)
func getFloat(_ hex: Color) -> Float {
    switch(hex) {
    case Color(hex: NoteColors.Red.rawValue):       return 0
    case Color(hex: NoteColors.Orange.rawValue):    return 1
    case Color(hex: NoteColors.Yellow.rawValue):    return 2
    case Color(hex: NoteColors.Green.rawValue):     return 3
    case Color(hex: NoteColors.Blue.rawValue):      return 4
    case Color(hex: NoteColors.Purple.rawValue):    return 5
    case Color(hex: NoteColors.Red.rawValue):       return 6
    default:                                        return 2
    }
}

/// Returns dark color if using accent colors, light color otherwise
/// - Parameter accent: Provided accent color (red, orange, yellow, green blue, purple, pink) (Color)
/// - Returns: light or dark color (Color)
func ifYellowFG(accent: Color) -> Color {
    return (DefaultsManager.shared.useNoteAccents ? Color("ToolbarButtonAccentFGDark") : Color.primary.opacity(0.65))
}

func ifYellowBG(accent: Color) -> Color {
    if (accent == Color(hex: NoteColors.Red.rawValue) && DefaultsManager.shared.useNoteAccents) {
        return Color(hex: 0x000000).opacity(0.17)
    } else if ((accent == Color(hex: NoteColors.Orange.rawValue) || accent == Color(hex: NoteColors.Yellow.rawValue)) && DefaultsManager.shared.useNoteAccents) {
        return Color(hex: 0x000000).opacity(0.09)
    } else {
        return Color("ToolbarButtonBGHovered")
    }
}
