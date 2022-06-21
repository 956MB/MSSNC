//
//  MSSNCWindowThin.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/26/21.
//

import SwiftUI

struct MSSNCWindowThin<Content>: View where Content: View {
    let color:   Color
    let content: Content

    init(color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.color   = color
        self.content = content()
    }

    func toolbarContent<ToolbarContent: View>(@ViewBuilder toolbar: @escaping () -> ToolbarContent) -> some View {
        ZStack(alignment: .top) {
            body
            toolbar()
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            content
            WindowRoundedToolbar(color: self.color, height: 28)
        }
    }
}

//struct MSSNCRoundedToolbarWindowThin_Previews: PreviewProvider {
//    static var previews: some View {
//        MSSNCWindowThin()
//    }
//}
