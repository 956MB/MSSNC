//
//  NoteTextEditorView.swift
//  MSSNC
//
//  Created by Trevor Bays on 8/1/21.
//

import SwiftUI
import HighlightedTextEditor

let betweenUnderscores = try! NSRegularExpression(pattern: "_[^_]+_", options: [])

struct NoteTextEditorView: View {

    @StateObject var MSSNCGlobal = MSSNCGlobalProperties.shared
    let def                      = DefaultsManager.shared

    @Binding var noteContent: String
    @Binding var subMenuShown:  Bool

    private let rules: [HighlightRule] = [
        HighlightRule(pattern: betweenUnderscores, formattingRules: [
            TextFormattingRule(fontTraits: [.bold]),
            TextFormattingRule(key: .backgroundColor, value: Color.red),
            TextFormattingRule(key: .underlineStyle) { content, range in
                if content.count > 10 { return NSUnderlineStyle.double.rawValue }
                else { return NSUnderlineStyle.single.rawValue }
            }
        ])
    ]

    var body: some View {
        HighlightedTextEditor(text: $noteContent, highlightRules: rules)
            .font(.system(size: CGFloat(self.def.fontSize)))
            .opacity(self.subMenuShown ? 0.3 : 1.0)
            .padding(.top, 48).padding([.leading, .trailing], 10).padding(.bottom, 62)
//            .background(Color.blue)
    }
}
