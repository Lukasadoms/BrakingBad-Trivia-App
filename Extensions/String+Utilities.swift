//
//  String+Utilities.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/24/21.
//

import Foundation

extension String {

    var emptyString: String {
        ""
    }

    var isNotEmpty: Bool {
        !isEmpty
    }

    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        formatter.timeZone = .autoupdatingCurrent
        return formatter.date(from: self)
    }
    
}

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
