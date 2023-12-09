//
//  FSCalendarRepresentable.swift
//  SimpleLedger
//


import SwiftUI
import FSCalendar

struct FSCalendarRepresentable: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var showingDetail: Bool

    class Coordinator: NSObject, FSCalendarDelegate {
        var parent: FSCalendarRepresentable

        init(parent: FSCalendarRepresentable) {
            self.parent = parent
        }

        // FSCalendar 的日期选择代理方法
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            parent.showingDetail = true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        // 在这里配置 FSCalendar 的其他属性
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // 当 SwiftUI 视图的状态改变时，更新 FSCalendar
    }
}


