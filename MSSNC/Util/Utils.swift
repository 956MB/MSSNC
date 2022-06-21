//
//  Utils.swift
//  MSSNC
//
//  Created by Trevor Bays on 8/1/21.
//

import SwiftUI

struct Execute : View {
    init( _ exec: () -> () ) {
        exec()
    }

    var body: some View {
        return EmptyView()
    }
}

func formattedCornerDate(lastOpened: Date) -> String {
    let dateFormatter = DateFormatter()

    let diffComponents = Calendar.current.dateComponents([.hour], from: lastOpened, to: Date())
    guard let hours = diffComponents.hour else {
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: Date())
    }

    if (hours >= 24) {
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: lastOpened)
    } else {
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: lastOpened)
    }
}
