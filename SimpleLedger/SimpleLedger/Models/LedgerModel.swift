//
//  LedgerModel.swift
//  SimpleLedger
//
//

import Foundation
import SwiftUI
import CloudKit

struct LedgerEntry: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var amount: Double
    var tagID: UUID
    var memo: String
    var date: String
    
    init(recordID: CKRecord.ID? = nil, amount: Double, tagID: UUID, memo: String, date: String) {
        self.recordID = recordID
        self.amount = amount
        self.tagID = tagID
        self.memo = memo
        self.date = date
    }
}

