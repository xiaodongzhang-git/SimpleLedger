//
//  SharedDateModel.swift
//  SimpleLedger
//
//  Created by xiaodong zhang on 2023/12/11.
//

import SwiftUI
import Combine

class SharedDateModel: ObservableObject {
    @Published var selectedDate: Date = Date()
}

