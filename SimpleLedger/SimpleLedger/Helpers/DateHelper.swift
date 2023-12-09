//
//  DateHelper.swift
//  SimpleLedger
//

import Foundation

struct DateHelper {
    static func formatDateToString(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
