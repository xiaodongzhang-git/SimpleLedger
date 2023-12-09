//
//  LedgerModel.swift
//  SimpleLedger
//
//

import Foundation
import SwiftUI

struct LedgerEntry: Identifiable {
    var id = UUID()
    var amount: Double
    var tagID: UUID
    var tagName: String
    var tagColor: Color
    var memo: String
    var date: String
}

