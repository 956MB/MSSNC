//
//  Notes.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/23/21.
//

//import MarkdownUI
import SwiftUI

enum MSSNCAppearance: Int, CaseIterable, Identifiable {
    case system, light, dark
    var id: Int { self.rawValue }
}
enum MSSNCAccent: Float, CaseIterable, Identifiable {
    case red    = 0
    case orange = 1
    case yellow = 2
    case green  = 3
    case blue   = 4
    case purple = 5
    case pink   = 6
    var id: Float { self.rawValue }
}
enum MSSNCTextMode: Int, CaseIterable, Identifiable {
    case plain    = 0
    case markdown = 1
    var id: Int { self.rawValue }
}

open class StickNote : NSObject {

    var title       : String
    var lastOpened  : Date
    var open        : Bool
    var accent      : NoteColors
    var content     : String
    var windowPosX  : CGFloat
    var windowPosY  : CGFloat
    var windowSizeW : CGFloat
    var windowSizeH : CGFloat

    init(title: String, lastOpened: Date, open: Bool, accent: NoteColors, content: String, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.title       = title
        self.lastOpened  = lastOpened
        self.open        = open
        self.accent      = accent
        self.content     = content
        self.windowPosX  = x
        self.windowPosY  = y
        self.windowSizeW = w
        self.windowSizeH = h
    }
}

/// Note properties
public class NoteStruct: ObservableObject {
    @Published var title      : String     = "local_untitlednote".localized()
    @Published var lastOpened : Date       = Date()
    @Published var open       : Bool       = false
    @Published var accent     : Color      = Color(hex: NoteColors.Yellow.rawValue)
    @Published var dimensions : NoteWindow = NoteWindow()
    @Published var content    : String     = ""

    init(title: String?="local_untitlednote".localized(), lastOpened: Date?=Date(), open: Bool?=false, accent: Color?=Color(hex: NoteColors.Yellow.rawValue), dimensions: NoteWindow?=NoteWindow(), content: String?="") {
        self.title      = title!
        self.lastOpened = lastOpened!
        self.open       = open!
        self.accent     = accent!
        self.dimensions = dimensions!
        self.content    = content!
    }
}

/// Note window dimensions
public class NoteWindow: ObservableObject {
    @Published var posX : CGFloat = 0
    @Published var posY : CGFloat = 0
    @Published var winW : CGFloat = 300
    @Published var winH : CGFloat = 600

    init(posX: CGFloat?=0, posY: CGFloat?=0, winW: CGFloat?=300, winH: CGFloat?=600) {
        self.posX = posX!
        self.posY = posY!
        self.winW = winW!
        self.winH = winH!
    }
}
