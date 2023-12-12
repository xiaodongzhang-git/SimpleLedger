//
//  SimpleLedgerApp.swift
//  SimpleLedger
//
//  Created by xiaodong zhang on 2023/12/06.
//

import SwiftUI

@main
struct SimpleLedgerApp: App {
    private let persistence = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
