//
//  MSSNCApp.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/19/21.
//

import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    /// Creates main application window and applies NotificationCenter observers to window
    /// - Parameter notification: Notification
    func applicationDidFinishLaunching(_ notification: Notification) {

        // MARK: vvv using "last" here may have fixed window not being brought to front and given focus bug? i guess using "last" instead of semmingly obvious "first" is correct?
        if let window = NSApplication.shared.windows.last {
            window.titleVisibility            = .hidden
            window.titlebarAppearsTransparent = true
            window.isReleasedWhenClosed       = false
            window.setFrameAutosaveName("StickyNotes.List")

            // MARK: setting main window frame here immediately solves issue of window frame not being ready on start unil moved/resized
            MainWindowProperties.shared.mainWindow = window
            MainWindowProperties.shared.frame = window.frame

            NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: window, queue: nil) { _ in MainWindowProperties.shared.focus = false }
            NotificationCenter.default.addObserver(forName: NSWindow.didBecomeKeyNotification, object: window, queue: nil) { _ in MainWindowProperties.shared.focus = true }
            NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: window, queue: nil) { _ in MainWindowProperties.shared.frame = window.frame }
            NotificationCenter.default.addObserver(forName: NSWindow.didMoveNotification, object: window, queue: nil) { _ in MainWindowProperties.shared.frame = window.frame }
        }
    }

    /// Creates MSSNC aplication dock menu with task options
    /// - Parameter sender: NSApplication
    /// - Returns: NSMenu?
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let newNoteItem      = NSMenuItem(title: "New Note", action: #selector(AppDelegate.newNoteDock), keyEquivalent: "")
        let notesListItem    = NSMenuItem(title: "Notes List", action: #selector(AppDelegate.openNotesListDock), keyEquivalent: "")
        let settingsItem     = NSMenuItem(title: "Settings", action: #selector(AppDelegate.openSettingsDock), keyEquivalent: "")
        let showAllNotesItem = NSMenuItem(title: "Show All Notes", action: #selector(AppDelegate.showAllNotesDock), keyEquivalent: "")
        let hideAllNotesItem = NSMenuItem(title: "Hide All Notes", action: #selector(AppDelegate.hideAllNotesDock), keyEquivalent: "")
        let menu             = NSMenu()

        menu.addItem(newNoteItem)
        menu.addItem(notesListItem)
        menu.addItem(settingsItem)
        menu.addItem(showAllNotesItem)
        menu.addItem(hideAllNotesItem)

        MainWindowProperties.shared.mainDockMenu = menu

        return menu
    }

    // MARK: - Dock icon functions
    ///
    /// NEW NOTE: creates new empty note
    @objc func newNoteDock(sender : NSMenuItem) {
        if (MainWindowProperties.shared.mainWindow != nil) {
            MainWindowProperties.shared.createNewNoteExternal = true
        }
    }
    /// NOTES LIST: shows main window and brings notes list to front
    @objc func openNotesListDock(sender : NSMenuItem) {
        // MARK: TODO: vvv this opening main window after its closed works, but clicking the app icon in dock again creates the window without the correct starting w/h
        if (MainWindowProperties.shared.mainWindow != nil) {
            MainWindowProperties.shared.mainWindow?.makeKeyAndOrderFront(nil)
        }
    }
    /// SETTINGS: shows main window and opens settings view
    @objc func openSettingsDock(sender : NSMenuItem) {
        if (MainWindowProperties.shared.mainWindow != nil) {
            MainWindowProperties.shared.mainWindow?.makeKeyAndOrderFront(nil)
        }
        MainWindowProperties.shared.settingsOpen = true
    }
    /// SHOW: shows all note windows and brings to front
    @objc func showAllNotesDock(sender : NSMenuItem) {
        MainWindowProperties.shared.showAllNotes = true
        MainWindowProperties.shared.showAllNotes = false
    }
    /// HIDE: hides all note windows and minimizes
    @objc func hideAllNotesDock(sender : NSMenuItem) {
        MainWindowProperties.shared.hideAllNotes = true
        MainWindowProperties.shared.showAllNotes = false
    }
}

@main
struct MSSNCApp: App {

    let persistenceContainer              = PersistenceController.shared
    @StateObject var MSSNCGlobal          = MSSNCGlobalProperties.shared
    @StateObject var mainWindowProperties = MainWindowProperties.shared

    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        DefaultsManager.shared.initSavedDefaults()
        updateAppIconRoot()
    }

    var body: some Scene {
        WindowGroup {
            MSSNCListScreen()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
                .onAppear {
                    pubShowNotesList()
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .commands(content: {
            CommandGroups()
        })
    }

    func updateAppIconRoot() {
        if (DefaultsManager.shared.useNoteAccents) {
            NSApplication.shared.applicationIconImage = NSImage(named: "AccentsIcon")
        } else {
            NSApplication.shared.applicationIconImage = NSImage(named: "NoAccentsIcon")
        }
    }

    public func pubShowNotesList() {
        if (MainWindowProperties.shared.mainWindow != nil) {
            MainWindowProperties.shared.mainWindow?.makeKeyAndOrderFront(nil)
        }
    }
}
