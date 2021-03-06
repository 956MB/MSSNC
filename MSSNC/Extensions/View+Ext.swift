//
//  View+Ext.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/22/21.
//

import Foundation
import SwiftUI

/// Gives views that classic macOS blurred glass transparent background
struct VisualEffectBackground: NSViewRepresentable {

    let material     : NSVisualEffectView.Material
    let blendingMode : NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView          = NSVisualEffectView()
        visualEffectView.material     = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state        = NSVisualEffectView.State.active

        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material     = material
        visualEffectView.blendingMode = blendingMode
    }
}

/// Rounds individual corners of view
struct RoundedCorners: Shape {
    var tl : CGFloat = 0.0
    var tr : CGFloat = 0.0
    var bl : CGFloat = 0.0
    var br : CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}

@available(OSX 11.0, *)
extension View {
    func dragWndWithClick() -> some View {
        self.overlay(DragWndView())
    }
}

struct DragWndView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        return DragWndNSView()
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}

class DragWndNSView: NSView {
    override public func mouseDown(with event: NSEvent) {
        NSApp?.mainWindow?.performDrag(with: event)
    }
}
