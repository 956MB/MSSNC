//
//  WindowRoundedToolbar.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/26/21.
//

import SwiftUI

struct WindowRoundedToolbar: View {
    let color:  Color
    let height: CGFloat

    var body: some View {
        ZStack {
//            HStack {
//            }
//            .frame(maxWidth: .infinity, maxHeight: self.height)
//            .background(RoundedCorners(tl: 0, tr: 0, bl: 10, br: 10).fill(Color("ToolbarBorderBottom")))
//            .padding([.top], 2)

            HStack {
            }
            .frame(maxWidth: .infinity, maxHeight: self.height)
            .background(RoundedCorners(tl: 0, tr: 0, bl: 10, br: 10).fill(self.color))
            .shadow(color: Color("ToolbarBorderBottom"), radius: 1, x: 0, y: 0)
//            .background(VisualEffectBackground(material: NSVisualEffectView.Material.menu, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color("ToolbarBorderBottom"), lineWidth: 1)
//            )
        }
//        .background(VisualEffectView2(material: NSVisualEffectView.Material.menu, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
//        .cornerRadius(10)
    }
}

//struct WindowRoundedToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        WindowRoundedToolbar()
//    }
//}
