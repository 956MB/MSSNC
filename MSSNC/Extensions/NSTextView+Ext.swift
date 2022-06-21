//
//  NSTextView+Ext.swift
//  MSSNC
//
//  Created by Trevor Bays on 7/26/21.
//

import SwiftUI

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear //<<here clear
            drawsBackground = true
        }
    }
}
