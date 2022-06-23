//
//  NSWindow+Ext.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/24/21.
//

import SwiftUI
import AppKit

//    @discardableResult
/// Creates then returns new NSWindow with supplied properties
/// - Parameters:
///   - noteWindowProps: NoteWindowProperties
///   - note: Binding\<NoteStruct\>
///   - title: Binding\<String\>
///   - useAccent: Binding\<Color\>
///   - selectedAccent: Binding\<Color\>
///   - noteContent: Binding\<String\>
///   - cellIndex: Binding\<Int\>
/// - Returns: NSWindow
public func newNoteWindow(noteWindowProps: NoteWindowProperties, note: Binding<NoteStruct>, title: Binding<String>, useAccent: Binding<Color>, selectedAccent: Binding<Color>, noteContent: Binding<String>, cellIndex: Binding<Int>) -> NSWindow {

    let window = NSWindow(
        contentRect: NSRect(x: note.dimensions.posX.wrappedValue, y: note.dimensions.posY.wrappedValue, width: note.dimensions.winW.wrappedValue, height: note.dimensions.winH.wrappedValue),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    )

    // MARK: set frame specs in window props here initially, then only update frame on resize
    noteWindowProps.frame = CGRect(x: note.dimensions.posX.wrappedValue, y: note.dimensions.posY.wrappedValue, width: note.dimensions.winW.wrappedValue, height: note.dimensions.winH.wrappedValue)
    let contentView = MSSNCNoteScreen(note: note, title: title, useAccent: useAccent, selectedAccent: selectedAccent, noteContent: noteContent, cellIndex: cellIndex)
        .environmentObject(noteWindowProps)

    createWindowPropertiesObservers(noteWindowProps: noteWindowProps, window: window)

    let customToolbar                                  = NSToolbar()
    customToolbar.showsBaselineSeparator               = false
    window.titlebarAppearsTransparent                  = true
    window.titleVisibility                             = .hidden
    window.toolbar                                     = customToolbar
    window.isReleasedWhenClosed                        = true
    window.contentView                                 = NSHostingView(rootView: contentView)
    window.contentView?.postsFrameChangedNotifications = true

    window.makeKeyAndOrderFront(nil)

    return window
}

/// Create NotificationCenter observers for supplied NSWindow, updates supplied NoteWindowProperties values
/// - Parameters:
///   - noteWindowProps: NoteWindowProperties
///   - window: NSWindow
func createWindowPropertiesObservers(noteWindowProps: NoteWindowProperties, window: NSWindow) {
    NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: window, queue: nil) { _ in noteWindowProps.hasFocus = false }
    NotificationCenter.default.addObserver(forName: NSWindow.didBecomeKeyNotification, object: window, queue: nil) { _ in noteWindowProps.hasFocus = true }
    NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: nil, queue: nil) { _ in noteWindowProps.frame = window.frame }
    NotificationCenter.default.addObserver(forName: NSWindow.didMoveNotification, object: window, queue: nil) { _ in noteWindowProps.frame = window.frame }
    NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: window, queue: nil) { _ in noteWindowProps.noteOpen = false }
}

/// Creates 'About MSSNC' window
public func createAboutWindow() {
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 320, height: 170),
        styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    )
    let contentView = MSSNCAboutScreen()
        .edgesIgnoringSafeArea(.top)

    window.titlebarAppearsTransparent                  = true
    window.isReleasedWhenClosed                        = false
//    window.styleMask.remove(.resizable)
    window.contentMinSize                              = NSSize(width: 320, height: 170) // <- doesnt work
    window.contentMaxSize                              = NSSize(width: 320, height: 170)
    window.contentView                                 = NSHostingView(rootView: contentView)
    window.contentView?.postsFrameChangedNotifications = true
    window.center()

    window.makeKeyAndOrderFront(nil)
}
