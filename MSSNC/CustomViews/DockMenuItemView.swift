//
//  DockMenuItemView.swift
//  MSSNC
//
//  Created by Alexander Bays on 7/26/21.
//

import SwiftUI

struct DockMenuItemView: View {
    var title        : String
    var imageNmae    : String
    var buttonAction : () -> Void

    var body: some View {
        Button(action: self.buttonAction, label: {
            HStack {
                Image(systemName: self.imageNmae)
                Text(self.title)
            }
        })
    }
}
