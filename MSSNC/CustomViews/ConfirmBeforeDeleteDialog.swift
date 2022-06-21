//
//  ConfirmBeforeDeleteDialog.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/29/21.
//

import SwiftUI

struct ConfirmBeforeDeleteDialog: View {

    @StateObject var MSSNCGlobal = MSSNCGlobalProperties.shared
    // MARK: BUG: confirm delete is active, when clicking black space above cell it bugs out the cells hovered property and corner text visibility

    var body: some View {
        VStack(alignment: .center) {
            /// dismiss area top
            HStack {
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedCorners(tl: 7, tr: 7, bl: 7, br: 7).fill(Color(hex: 0xFFFFFF).opacity(0.001)))
            .gesture(TapGesture(count: 1).onEnded {
                self.cancelDeleteNote()
            })

            HStack {
                VStack(alignment: .center) {
                    if (DefaultsManager.shared.useNoteTitles) {
                        VStack(alignment: .center, spacing: 10) {
                            /// note title
                            Text("\"\(self.MSSNCGlobal.deleteNoteTitle)\"")
                                .italic()
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.center)
                            /// confirm delete message
                            Text("local_confirmdeletetitle".localized())
                                .font(.system(size: 15, weight: .regular))
                                .multilineTextAlignment(.center)
                        }
                        .padding([.leading, .top, .trailing], 18).padding(.bottom, 4)
                    } else {
                        HStack() {
                            /// confirm delete message
                            Text("local_confirmdeletetitle".localized())
                                .font(.system(size: 15, weight: .regular))
                                .multilineTextAlignment(.center)
                        }
                        .padding([.leading, .top, .trailing], 18).padding(.bottom, 4)
                    }

                    /// cancel / delete buttons
                    HStack(alignment: .center, spacing: 8) {
                        ConfirmBeforeDeleteButton(buttonAction: {self.cancelDeleteNote()}, buttonText: "local_cancel".localized(), buttonHelp: "local_cancel".localized())
                        ConfirmBeforeDeleteButton(buttonAction: {self.confirmDeleteNote()}, buttonText: "local_delete".localized(), buttonHelp: "local_delete".localized())
                    }
                    .padding(8)
                }
                .background(VisualEffectBackground(material: NSVisualEffectView.Material.menu, blendingMode: NSVisualEffectView.BlendingMode.withinWindow))
                .cornerRadius(7)
                .padding([.leading, .trailing])
            }

            /// dismiss area bottom
            HStack {
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedCorners(tl: 7, tr: 7, bl: 7, br: 7).fill(Color(hex: 0xFFFFFF).opacity(0.001)))
            .gesture(TapGesture(count: 1).onEnded {
                self.cancelDeleteNote()
            })
        }
        .background(Color("ConfirmDeleteOverlayBG"))
    }

    func confirmDeleteNote() {
        self.MSSNCGlobal.confirmDeleteMainShown       = false
        self.MSSNCGlobal.confirmDeleteNoteWindowShown = false
        self.MSSNCGlobal.deleteNoteWindow             = self.MSSNCGlobal.confirmDeleteNoteIndex
    }
    func cancelDeleteNote() {
        self.MSSNCGlobal.confirmDeleteMainShown       = false
        self.MSSNCGlobal.confirmDeleteNoteWindowShown = false
        self.MSSNCGlobal.deleteNoteWindow             = -1
    }
}

struct ConfirmBeforeDeleteButton: View {
    var buttonAction         : () -> Void
    @State var buttonHovered : Bool = false
    var buttonText           : String
    var buttonHelp           : String

    var body: some View {
        Button(action: {
            self.buttonAction()
        }) {
            HStack {
                Spacer()
                HStack(alignment: .center) {
                    Text(self.buttonText)
                        .foregroundColor(self.buttonHovered ? Color("PopoverFGHovered") : Color("PopoverFG"))
                }
                Spacer()
            }
            .frame(minWidth: 11, minHeight: 11)
            .padding(6).padding([.top, .bottom], 3)
            .contentShape(RoundedRectangle(cornerSize: CGSize(width: 7, height: 7)))
        }
        .buttonStyle(PlainButtonStyle())
        .background(self.buttonHovered ? Color("NoteCellViewBGHovered") : Color("NoteCellViewBG"))
        .onHover {_ in self.buttonHovered.toggle()}
        .cornerRadius(7)
        .help(self.buttonHelp)
    }
}
