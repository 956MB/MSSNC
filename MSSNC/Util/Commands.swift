//
//  Commands.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/24/21.
//

import SwiftUI

struct CommandGroups: Commands {

    let Defaults = DefaultsManager.shared
    @StateObject var mainWindowProperties = MainWindowProperties.shared
    @StateObject var MSSNCGlobal          = MSSNCGlobalProperties.shared

    var body: some Commands {
        /// MSSNC:
        CommandGroup(replacing: CommandGroupPlacement.appInfo) {
            Button(action: {
                createAboutWindow()
            }) {
                Text("local_aboutmssnc".localized())
            }

            Divider()

            Button("local_settingstitle".localized()) {
//                print("preferencfdsf343333es")
                MainWindowProperties.shared.settingsOpen = !self.mainWindowProperties.settingsOpen
                if (MainWindowProperties.shared.mainWindow != nil) {
                    MainWindowProperties.shared.mainWindow?.makeKeyAndOrderFront(nil)
                    // MARK: does not bring main window to front and give focus
//                    print("open setitnggf")
                }
//                MainWindowProperties.shared.settingsOpen.toggle()
            }.keyboardShortcut(",", modifiers: [.command])
        }
        ///


        /// FILE: create new note from command/shortcut
        CommandGroup(replacing: CommandGroupPlacement.newItem) {
            Button("local_newnote".localized()) {
                // MARK: not using duplicate right now because of bugged double exec
                self.MSSNCGlobal.createNewNoteCommand = true
            }.keyboardShortcut("N", modifiers: [.command])

            Button("local_deletenote".localized()) {
                self.MSSNCGlobal.deleteNoteCommand = true
            }.keyboardShortcut("D", modifiers: [.command])
            .disabled(self.MSSNCGlobal.focusedNote == -1)
        }
        ///


        /// EDIT:
        CommandGroup(after: CommandGroupPlacement.textEditing) {
            Menu("local_fontsize".localized(), content: {
                /// FONT: size increase
                Button("local_fontsizeincrease".localized()){
                    self.Defaults.fontSize = self.Defaults.fontSize <= 25 ? (self.Defaults.fontSize + 1) : self.Defaults.fontSize
                    self.Defaults.setKeyValue(key: "key_fontSize", value: self.Defaults.fontSize)
                }.keyboardShortcut("+", modifiers: [.command])
                
                /// FONT: size decrease
                Button("local_fontsizedecrease".localized()){
                    self.Defaults.fontSize = self.Defaults.fontSize >= 10 ? (self.Defaults.fontSize - 1) : self.Defaults.fontSize
                    self.Defaults.setKeyValue(key: "key_fontSize", value: self.Defaults.fontSize)
                }.keyboardShortcut("-", modifiers: [.command])

                Divider()

                /// FONT: size reset
                Button("local_fontsizereset".localized()){
                    self.Defaults.fontSize = 14
                    self.Defaults.setKeyValue(key: "key_fontSize", value: self.Defaults.fontSize)
                }.keyboardShortcut("0", modifiers: [.command])
            })
        }
        ///


        /// WINDOW:
        CommandGroup(replacing: CommandGroupPlacement.windowList) {
            Button(action: {
            }) {
                Text("local_showallnotes".localized())
            }
            Button(action: {
            }) {
                Text("local_hideallnotes".localized())
            }
        }
        ///

        /// VIEW:
        CommandGroup(before: CommandGroupPlacement.appSettings) {
            Button(action: {
            }) {
                Text("1111111111")
            }
        }
        CommandGroup(before: CommandGroupPlacement.windowArrangement) {
            Button(action: {
            }) {
                Text("2222222222")
            }
        }
        CommandGroup(before: CommandGroupPlacement.windowSize) {
            Button(action: {
            }) {
                Text("33333333333333")
            }
        }
//        CommandGroup(replacing: CommandGroupPlacement.windowList) {
//            Button(action: {
//            }) {
//                Text("4444444444444")
//            }
//        }
        CommandGroup(before: CommandGroupPlacement.textFormatting) {
            Button(action: {
            }) {
                Text("55555555555")
            }
        }
        CommandGroup(before: CommandGroupPlacement.textEditing) {
            Button(action: {
            }) {
                Text("666666666")
            }
        }
        CommandGroup(before: CommandGroupPlacement.appVisibility) {
            Button(action: {
            }) {
                Text("777777777")
            }
        }
        ///
    }
}
