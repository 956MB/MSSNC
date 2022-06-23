//
//  MSSNCWindowRegular.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/26/21.
//

import SwiftUI

struct MSSNCWindowRegular<Content>: View where Content: View {
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
            WindowRoundedToolbar(color: self.color, height: 37)
        }
    }
}

//struct MSSNCWindowRegular_Previews: PreviewProvider {
//    static var previews: some View {
//        MSSNCWindowRegular()
//    }
//}
