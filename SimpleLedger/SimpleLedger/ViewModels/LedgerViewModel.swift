//
//  LedgerViewModel.swift
//  SimpleLedger
//

import Foundation
import SwiftUI

class LedgerViewModel: ObservableObject {
    @Published var entries: [LedgerEntry] = []

    // 示例方法：添加一个 LedgerEntry
    func addEntry(amount: Double, tagID: UUID, tagName: String, tagColor: Color, memo: String, date: Date) {
        let newEntry = LedgerEntry(amount: amount, tagID: tagID, tagName: tagName, tagColor: tagColor, memo: memo, date: DateHelper.formatDateToString(date))
        entries.append(newEntry)
        print("Entry added: \(newEntry)")
    }
    
    func getEntriesByDate(for date: Date) -> [LedgerEntry] {
        return entries.filter { $0.date == DateHelper.formatDateToString(date) }
    }

}
