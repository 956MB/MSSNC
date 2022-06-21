//
//  MSSNCAboutScreen.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/26/21.
//

import SwiftUI

struct MSSNCAboutScreen: View {
    private var version: String

    init() {
        version = Bundle.main.releaseVersionNumber!
    }
    
    var body: some View {
        MSSNCWindowThin(color: Color("AccentDontShowToolbar"), content: {
            VStack {
                HStack(spacing: 18) {
                    Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)

                    VStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 25) {
                            VStack(alignment: .leading, spacing: -2) {
                                Text("MSSNC")
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .help("\"Microsoft Sticky Notes Clone\"")
                                Text("Version \(self.version) (12E507)")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            }
                            VStack(alignment: .leading) {
                                Text("Copyright © 1999-2021 Apple Inc. All rights reserved. Apple and the Apple logo are trademarks of Apple Inc., registered in the U.S. and other countries")
                                    .font(Font.system(size: 9, weight: .light))
                                    .foregroundColor(Color.gray)
                                    .lineLimit(3)
                            }
                        }.padding(.top, -3)
                        Spacer()
                    }
                    .frame(width: 245)

                    Spacer()
                }
                .padding(.leading, 18)
            }
            .padding(5).padding(.top, 28)
//            .frame(maxWidth: .infinity)
//            .frame(maxWidth: 320, maxHeight: 170)
            .background(VisualEffectBackground(material: NSVisualEffectView.Material.menu, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
        })
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
