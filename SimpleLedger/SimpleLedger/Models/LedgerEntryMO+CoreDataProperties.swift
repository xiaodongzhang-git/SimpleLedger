//
//  LedgerEntryMO+CoreDataProperties.swift
//  
//
//  Created by xiaodong zhang on 2023/12/12.
//
//

import Foundation
import CoreData


extension LedgerEntryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LedgerEntryMO> {
        return NSFetchRequest<LedgerEntryMO>(entityName: "LedgerEntryMO")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var tagID: TagEntryMo?

}
