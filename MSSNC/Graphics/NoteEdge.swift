//
//  NoteEdge.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/21/21.
//

import CoreGraphics
import SwiftUI

struct TriangleTopFlat: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        return path
    }
}
struct TriangleTopRound: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control1: CGPoint(x: rect.minX, y: rect.minY-3), control2: CGPoint(x: rect.minX-3, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//        path.stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))

        return path
    }
}

//struct TriangleBottom: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//
//        return path
//    }
//}

struct NoteEdgeRound: View {

    private var bgFill : Color
    private var fgFill : Color

    init(bgFill: Color, fgFill: Color) {
        self.bgFill = bgFill
        self.fgFill = fgFill
    }

    var body: some View {
        ZStack {
            TriangleTopFlat()
                .fill(self.bgFill)
            TriangleTopRound()
                .fill(self.fgFill)
        }
        .frame(width: 15, height: 15)
        .background(Color.clear)
    }
}
