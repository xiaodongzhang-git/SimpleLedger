//
//  TagEntryMo+CoreDataProperties.swift
//  
//
//  Created by xiaodong zhang on 2023/12/12.
//
//

import Foundation
import CoreData


extension TagEntryMo: Identifiable  {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntryMo> {
        return NSFetchRequest<TagEntryMo>(entityName: "TagEntryMo")
    }

    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var ledgerEntryMO: NSSet

}

// MARK: Generated accessors for ledgerEntryMO
extension TagEntryMo {

    @objc(addLedgerEntryMOObject:)
    @NSManaged public func addToLedgerEntryMO(_ value: LedgerEntryMO)

    @objc(removeLedgerEntryMOObject:)
    @NSManaged public func removeFromLedgerEntryMO(_ value: LedgerEntryMO)

    @objc(addLedgerEntryMO:)
    @NSManaged public func addToLedgerEntryMO(_ values: NSSet)

    @objc(removeLedgerEntryMO:)
    @NSManaged public func removeFromLedgerEntryMO(_ values: NSSet)

}
