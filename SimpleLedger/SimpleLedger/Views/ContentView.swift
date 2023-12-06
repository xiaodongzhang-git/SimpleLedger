//
//  ContentView.swift
//  SimpleLedger
//
//  Created by xiaodong zhang on 2023/12/06.
//

import SwiftUI

struct ContentView: View {
    // 使用枚举来表示不同的视图选项
    enum Tab {
        case calendar, chart, tag
    }

    // @State 用于跟踪当前选中的视图
    @State private var selectedTab: Tab = .calendar

    var body: some View {
        VStack {
            // 顶部栏
            HStack {
                Text("家计名称")
                Spacer()
                Image(systemName: "gear")
            }
            .padding()

            // 中间内容区域
            Spacer()
            selectedView
            Spacer()

            // 底部图标栏
            HStack {
                // 日历视图按钮
                Button(action: { self.selectedTab = .calendar }) {
                    Image(systemName: "calendar")
                }

                Spacer()

                // 图表视图按钮
                Button(action: { self.selectedTab = .chart }) {
                    Image(systemName: "chart.bar")
                }

                Spacer()

                // 标签管理视图按钮
                Button(action: { self.selectedTab = .tag }) {
                    Image(systemName: "tag")
                }
            }
            .padding()
        }
    }

    // 根据当前选中的标签返回对应的视图
    @ViewBuilder
    private var selectedView: some View {
        switch selectedTab {
        case .calendar:
            CalendarView()
        case .chart:
            ChartView()
        case .tag:
            TagView()
        }
    }
}

// 以下为预览提供器
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
