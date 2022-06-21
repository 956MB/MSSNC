//
//  DefaultsManager.swift
//  MSSNC
//
//  Created by Trevor Bays on 8/2/21.
//

import Foundation
import SwiftUI

/// Class holding all settings defaults to be used in StickyNotes
class DefaultsManager: ObservableObject {

    static let shared = DefaultsManager()
    let defaults      = UserDefaults.standard

    @Published public var confirmBeforeDelete   : Bool  = true
    @Published public var autoSaveChanges       : Bool  = true
    @Published public var openNotesListOnLaunch : Bool  = true
    @Published public var useNoteTitles         : Bool  = false
    @Published public var fontSize              : Int   = 14
    @Published public var cellLineLimit         : Int   = 4
    @Published public var textMode              : Int   = MSSNCTextMode.plain.rawValue
    @Published public var appearance            : Int   = MSSNCAppearance.system.rawValue
    @Published public var defaultAccent         : Float = MSSNCAccent.yellow.rawValue
    @Published public var useNoteAccents        : Bool  = true

    /// Inits DefaultsManager variables from saved UserDefaults.standard
    public func initSavedDefaults() {
        // Reset Standard User Defaults
//        if ProcessInfo.processInfo.environment["clear_defaults"] == "true" {
//            UserDefaults.resetStandardUserDefaults()
//        }

        let key_confirmBeforeDelete   = defaults.value(forKey: "key_confirmBeforeDelete")   as? Bool  ?? true
        let key_autoSaveChanges       = defaults.value(forKey: "key_autoSaveChanges")       as? Bool  ?? true
        let key_openNotesListOnLaunch = defaults.value(forKey: "key_openNotesListOnLaunch") as? Bool  ?? true
        let key_useNoteTitles         = defaults.value(forKey: "key_useNoteTitles")         as? Bool  ?? false
        let key_fontSize              = defaults.value(forKey: "key_fontSize")              as? Int   ?? 14
        let key_cellLineLimit         = defaults.value(forKey: "key_cellLineLimit")         as? Int   ?? 4
        let key_textMode              = defaults.value(forKey: "key_textMode")              as? Int   ?? MSSNCTextMode.plain.rawValue
        let key_appearance            = defaults.value(forKey: "key_appearance")            as? Int   ?? MSSNCAppearance.system.rawValue
        let key_defaultAccent         = defaults.value(forKey: "key_defaultAccent")         as? Float ?? MSSNCAccent.yellow.rawValue
        let key_useNoteAccents        = defaults.value(forKey: "key_useNoteAccents")        as? Bool  ?? true

        self.confirmBeforeDelete   = key_confirmBeforeDelete
        self.autoSaveChanges       = key_autoSaveChanges
        self.openNotesListOnLaunch = key_openNotesListOnLaunch
        self.useNoteTitles         = key_useNoteTitles
        self.fontSize              = key_fontSize
        self.cellLineLimit         = key_cellLineLimit
        self.textMode              = key_textMode
        self.appearance            = key_appearance
        self.defaultAccent         = key_defaultAccent
        self.useNoteAccents        = key_useNoteAccents

//        print(self.appearance)
    }

    /// Sets supplied key in DefaultsManager with supplied value, then saves to UserDefaults.standard
    /// - Parameters:
    ///   - key: String
    ///   - value: Any?
    public func setKeyValue(key: String, value: Any?) {
        switch (key) {
            case "key_confirmBeforeDelete":   self.confirmBeforeDelete   = value as! Bool;  break
            case "key_autoSaveChanges":       self.autoSaveChanges       = value as! Bool;  break
            case "key_openNotesListOnLaunch": self.openNotesListOnLaunch = value as! Bool;  break
            case "key_useNoteTitles":         self.useNoteTitles         = value as! Bool;  break
            case "key_fontSize":              self.fontSize              = value as! Int;   break
            case "key_cellLineLimit":         self.cellLineLimit         = value as! Int;   break
            case "key_textMode":              self.textMode              = value as! Int;   break
            case "key_appearance":            self.appearance            = value as! Int;   break
            case "key_defaultAccent":         self.defaultAccent         = value as! Float; break
            case "key_useNoteAccents":        self.useNoteAccents        = value as! Bool;  break
            default:                                                                        break
        }

        defaults.setValue(value, forKey: key)
    }
}
