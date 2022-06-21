//
//  MSSNCSettingsScreen.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/22/21.
//

import SwiftUI

struct MSSNCSettingsScreen: View {

    @StateObject var MSSNCGlobal = MSSNCGlobalProperties.shared
    let def                      = DefaultsManager.shared

    @State private var confirmBeforeDelete   : Bool
    @State private var autoSaveChanges       : Bool
    @State private var openNotesListOnLaunch : Bool
    @State private var useNoteTitles         : Bool
    @State private var appearance            : Int
    @State private var cellLineLimit         : Int
    @State private var textMode              : Int
    @State private var fontSize              : Int
    @State private var defaultAccent         : Float
    @State private var useNoteAccents        : Bool

    @State private var settingsHover = false

    init() {
        self.confirmBeforeDelete   = def.confirmBeforeDelete
        self.autoSaveChanges       = def.autoSaveChanges
        self.openNotesListOnLaunch = def.openNotesListOnLaunch
        self.useNoteTitles         = def.useNoteTitles
        self.appearance            = def.appearance
        self.cellLineLimit         = def.cellLineLimit
        self.textMode              = def.textMode
        self.fontSize              = def.fontSize
        self.defaultAccent         = def.defaultAccent
        self.useNoteAccents        = def.useNoteAccents
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    /// general section
                    VStack(alignment: .leading) {
                        SettingsSectionTitle(titleKey: "local_settingsgeneral")
                            .dragWndWithClick()

                        VStack(alignment: .leading, spacing: 10) {
                            SettingsCheckbox(isOn: self.$confirmBeforeDelete, toggleKey: "local_confirmdelete")
                                .onChange(of: self.confirmBeforeDelete) { _ in
                                    def.setKeyValue(key: "key_confirmBeforeDelete", value: self.confirmBeforeDelete)
                                }
                            SettingsCheckbox(isOn: self.$openNotesListOnLaunch, toggleKey: "local_openonlaunch")
                                .onChange(of: self.openNotesListOnLaunch) { _ in
                                    def.setKeyValue(key: "key_openNotesListOnLaunch", value: self.openNotesListOnLaunch)
                                }
                        }
                        .padding(.leading, 30)

                    }
                    .padding([.top], 15)
                    .toggleStyle(CheckboxToggleStyle())


                    /// notes section
                    VStack(alignment: .leading) {
                        SettingsSectionTitle(titleKey: "local_settingsnotes")

                        VStack(alignment: .leading, spacing: 10) {
                            SettingsCheckbox(isOn: self.$useNoteTitles, toggleKey: "local_usetitles")
                                .onChange(of: self.useNoteTitles) { _ in
                                    def.setKeyValue(key: "key_useNoteTitles", value: self.useNoteTitles)
                                }
                            SettingsCheckbox(isOn: self.$autoSaveChanges, toggleKey: "local_autosave")
                                .onChange(of: self.autoSaveChanges) { _ in
                                    def.setKeyValue(key: "key_autoSaveChanges", value: self.autoSaveChanges)
                                }
                        }
                        .padding(.leading, 30)
                        .padding(.bottom, 10)

                        /// PICKER: font size
                        SettingsPicker(title: "local_fontsize".localized(), key: "key_fontSize", change: self.$fontSize, opacity: 1.0, useAccents: self.$useNoteAccents, content: {
                            Picker(selection: self.$fontSize, label: EmptyView()) {
                                ForEach(10..<25) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                        })
                        /// PICKER: text mode
                        SettingsPicker(title: "local_settingstextmode".localized(), key: "key_textMode", change: self.$textMode, opacity: 1.0, useAccents: self.$useNoteAccents, content: {
                            Picker(selection: self.$textMode, label: EmptyView()) {
                                Text("local_settingstextmodeplain".localized()).tag(MSSNCTextMode.plain.rawValue)
                                Text("local_settingstextmodemarkdown".localized()).tag(MSSNCTextMode.markdown.rawValue)
                            }
                        })
                        /// PICKER: line limit
                        SettingsPicker(title: "local_settingslinelimit".localized(), key: "key_cellLineLimit", change: self.$cellLineLimit, opacity: 1.0, useAccents: self.$useNoteAccents, content: {
                            Picker(selection: self.$cellLineLimit, label: EmptyView()) {
                                ForEach(1..<8) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                        })

                    }
//                    .padding([.top], 15)
                    .toggleStyle(CheckboxToggleStyle())


                    /// colors section
                    VStack(alignment: .leading) {
                        SettingsSectionTitle(titleKey: "local_settingscolor")

                        /// PICKER: appearance
                        SettingsPicker(title: "local_settingsappearance".localized(), key: "key_appearance", change: self.$appearance, opacity: 1.0, useAccents: self.$useNoteAccents, content: {
                            Picker(selection: self.$appearance, label: EmptyView()) {
                                Text("local_settingsthemesystem".localized()).tag(MSSNCAppearance.system.rawValue)
                                Divider()
                                Text("local_settingsthemelight".localized()).tag(MSSNCAppearance.light.rawValue)
                                Text("local_settingsthemedark".localized()).tag(MSSNCAppearance.dark.rawValue)
                            }
                        })

                        /// PICKER: default accent
                        HStack {
                            Text("\("local_settingsdefaultaccent".localized()):")
                                .opacity(self.useNoteAccents ? 1 : 0.4)
                            Spacer()
                            Picker(selection: self.$defaultAccent, label: EmptyView()) {
                                Text("local_accentred".localized()).tag(MSSNCAccent.red.rawValue)
                                Text("local_accentorange".localized()).tag(MSSNCAccent.orange.rawValue)
                                Text("local_accentyellow".localized()).tag(MSSNCAccent.yellow.rawValue)
                                Text("local_accentgreen".localized()).tag(MSSNCAccent.green.rawValue)
                                Text("local_accentblue".localized()).tag(MSSNCAccent.blue.rawValue)
                                Text("local_accentpurple".localized()).tag(MSSNCAccent.purple.rawValue)
                                Text("local_accentpink".localized()).tag(MSSNCAccent.pink.rawValue)
                            }
                            .onChange(of: self.defaultAccent, perform: { _ in
                                def.setKeyValue(key: "key_defaultAccent", value: self.defaultAccent)
                            })
                            .frame(width: 120, alignment: .leading)
                        }
                        .disabled(!self.useNoteAccents)
                        .padding([.leading, .trailing], 30)

                        HStack {
                            SettingsCheckbox(isOn: self.$useNoteAccents, toggleKey: "local_showaccentcolors")
                                .onChange(of: self.useNoteAccents) { _ in
                                    def.setKeyValue(key: "key_useNoteAccents", value: self.useNoteAccents)
                                    updateAppIcon()
                                }
                        }
                        .padding(.leading, 30).padding(.bottom, 15)
                    }
                }
            }
//            .background(RoundedCorners(tl: 6, tr: 6, bl: 6, br: 6).fill(Color("SettingsContainerBG")))
            .background(VisualEffectBackground(material: NSVisualEffectView.Material.menu, blendingMode: NSVisualEffectView.BlendingMode.withinWindow))
//            .cornerRadius(6)
////            .shadow(color: Color("SettingsContainerBorder"), radius: 5, x: 0, y: 0)
//            // MARK: border every side but right 2/3 pixels thick, instead of intended 1 pixel thick, BUG, apparently doesnt happen when not using display, using just macbook screen
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("SettingsContainerBorder"), lineWidth: 1)
            )

            Spacer()
        }
        .padding([.leading, .trailing], 15)
//        .padding([.bottom], 2).padding(.top, 37)
        .padding([.bottom], 7).padding(.top, 53)

        /// FONT: change of font size in default manager
        .onReceive(self.def.$fontSize, perform: { fontSizeN in
            self.fontSize = fontSizeN
        })
    }

    func updateAppIcon() {
        if (self.useNoteAccents) {
            NSApplication.shared.applicationIconImage = NSImage(named: "AccentsIcon")
        } else {
            NSApplication.shared.applicationIconImage = NSImage(named: "NoAccentsIcon")
        }
    }
}
