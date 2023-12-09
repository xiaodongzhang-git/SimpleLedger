//
//  LedgerViewModel.swift
//  SimpleLedger
//

import CloudKit
import SwiftUI

class LedgerViewModel: ObservableObject {
    @Published var entries: [LedgerEntry] = []
    private let database = CKContainer.default().privateCloudDatabase
    
    init() {
        fetchAllEntries()
    }

    // 保存 LedgerEntry
    func addEntry(amount: Double, tagID: UUID, memo: String, date: Date) {
        let newEntry = CKRecord(recordType: "LedgerEntry")
        newEntry["amount"] = amount
        newEntry["tagID"] = tagID.uuidString
        newEntry["memo"] = memo
        newEntry["date"] = DateHelper.formatDateToString(date)

        database.save(newEntry) { [weak self] record, error in
            guard let self = self, let record = record, error == nil else {
                print("Error saving record: \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                let ledgerEntry = LedgerEntry(
                    recordID: record.recordID,
                    amount: amount,
                    tagID: tagID,
                    memo: memo,
                    date: DateHelper.formatDateToString(date)
                )
                self.entries.append(ledgerEntry)
            }
        }
    }

    // 删除 LedgerEntry
    func deleteEntry(recordID: CKRecord.ID) {
        database.delete(withRecordID: recordID) { [weak self] recordID, error in
            guard let self = self, error == nil else {
                print("Error deleting record: \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.entries.removeAll { $0.recordID == recordID }
            }
        }
    }

    // 修改 LedgerEntry
    func updateEntry(recordID: CKRecord.ID, newAmount: Double, newTagID: UUID, newMemo: String) {
        database.fetch(withRecordID: recordID) { [weak self] record, error in
            guard let self = self, let record = record, error == nil else {
                print("Error fetching record: \(error?.localizedDescription ?? "")")
                return
            }
            record["amount"] = newAmount
            record["tagID"] = newTagID.uuidString
            record["memo"] = newMemo

            self.database.save(record) { _, error in
                if let error = error {
                    print("Error updating record: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    if let index = self.entries.firstIndex(where: { $0.recordID == recordID }) {
                        self.entries[index].amount = newAmount
                        self.entries[index].tagID = newTagID
                        self.entries[index].memo = newMemo
                    }
                }
            }
        }
    }

    // 加载所有 LedgerEntry
    private func fetchAllEntries() {
        let query = CKQuery(recordType: "LedgerEntry", predicate: NSPredicate(value: true))
        let operation = CKQueryOperation(query: query)

        var fetchedEntries: [LedgerEntry] = []
        operation.recordMatchedBlock = { (recordID, recordResult) in
            switch recordResult {
            case .failure(let error):
                print("Error fetching record: \(error)")
            case .success(let record):
                let ledgerEntry = LedgerEntry(
                    recordID: record.recordID,
                    amount: record["amount"] as? Double ?? 0,
                    tagID: UUID(uuidString: record["tagID"] as? String ?? "") ?? UUID(),
                    memo: record["memo"] as? String ?? "",
                    date: record["date"] as? String ?? ""
                )
                fetchedEntries.append(ledgerEntry)
            }
        }

        operation.queryResultBlock = { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error querying records: \(error)")
            case .success(_):
                DispatchQueue.main.async {
                    self?.entries = fetchedEntries
                }
            }
        }

        database.add(operation)
        print(self.entries)
    }

    // 筛选特定日期的 LedgerEntry
    func entries(for date: Date) -> [LedgerEntry] {
        return entries.filter { $0.date == DateHelper.formatDateToString(date) }
    }
    
}
