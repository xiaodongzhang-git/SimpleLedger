//
//  FSCalendarRepresentable.swift
//  SimpleLedger
//
//  Created by xiaodong zhang on 2023/12/06.
//

import SwiftUI
import FSCalendar

struct FSCalendarRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        // 在此处配置 FSCalendar 的属性
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // 当 SwiftUI 视图的状态改变时，更新 FSCalendar
    }
}


struct FSCalendarRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        FSCalendarRepresentable()
    }
}
