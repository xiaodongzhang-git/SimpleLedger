//
//  FSCalendarRepresentable.swift
//  SimpleLedger
//

import SwiftUI
import FSCalendar

struct FSCalendarRepresentable: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var showingDetail: Bool
    var viewModel: LedgerViewModel  // LedgerViewModel 实例

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: FSCalendarRepresentable

        init(parent: FSCalendarRepresentable) {
            self.parent = parent
        }

        // FSCalendar 的日期选择代理方法
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            parent.showingDetail = true
        }

        // FSCalendarDataSource 方法来提供每个日期的子标题
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            let totalAmount = parent.viewModel.totalAmountPerDay()[date]
            return totalAmount != nil ? String(format: "%.2f", totalAmount!) : nil
        }
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        viewModel.onDataLoaded = {
            calendar.reloadData()
        }
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }
}

