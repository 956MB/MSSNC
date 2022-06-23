//
//  Utils.swift
//  MSSNC
//
//  Created by Alexander Bays on 8/1/21.
//

import SwiftUI

/// Allows mid view code execution by running code then returning EmptyView()
struct Execute : View {
    init( _ exec: () -> () ) {
        exec()
    }

    var body: some View {
        return EmptyView()
    }
}

/// Formats supplied date (Date) into simplified strings
/// - Parameter lastOpened: Note last opened date (Date)
/// - Returns: Formatted date string (String)
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
