//
//  SettingsViews.swift
//  MSSNC
//
//  Created by Trevor Bays on 12/24/21.
//

import SwiftUI

struct SettingsSectionTitle: View {
    var titleKey: String
    var body: some View {
        HStack {
//            line
            Text(self.titleKey.localized())
                .foregroundColor(Color.secondary.opacity(0.85))
                .font(.system(size: 13, weight: .regular))
                .padding([.leading], 15)
            line
        }
        .padding([.bottom], 8)
    }
}

struct SettingsCheckbox: View {
    @Binding var isOn: Bool
    var toggleKey: String

    var body: some View {
        HStack {
            Toggle(isOn: self.$isOn) {
                Text(self.toggleKey.localized())
                    .foregroundColor(.primary)
                    .padding(.leading, 8)
            }
        }
    }
}

struct SettingsPicker<Content>: View where Content: View {
    let title:               String
    let key:                 String
    @Binding var change:     Int
    let opacity:             Double
    @Binding var useAccents: Bool
    let content:             Content

    let def = DefaultsManager.shared

    init(title: String, key: String, change: Binding<Int>, opacity: Double, useAccents: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.title        = title
        self.key          = key
        self._change      = change
        self.opacity      = opacity
        self._useAccents  = useAccents
        self.content      = content()
    }

    var body: some View {
        HStack {
            Text("\(self.title):")
                .opacity(self.useAccents ? 1 : opacity)

            Spacer()

            content
            .onChange(of: self.change, perform: { _ in
                def.setKeyValue(key: self.key, value: self.change)
            })
            .frame(width: 120, alignment: .leading)
        }
        .padding([.leading, .trailing], 30)
    }
}

var line: some View {
    VStack {
        Divider()
        .padding(.leading, 5)
    }
}
