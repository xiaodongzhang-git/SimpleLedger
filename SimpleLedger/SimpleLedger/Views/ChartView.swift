//
//  ChartView.swift
//  SimpleLedger
//

import SwiftUI

// 更新后的ExpenseData，包含颜色字段
struct ExpenseData {
    var tag: String
    var amount: Double
    var color: Color
}

struct ChartView: View {
    @State private var selectedRange: DateRange = .day

    // 示例数据
    let dayData: [ExpenseData] = [
        ExpenseData(tag: "生活费", amount: 1000, color: .black),
        ExpenseData(tag: "学费", amount: 2000, color: .green)
        // 更多日数据...
    ]

    let weekData: [ExpenseData] = [
        ExpenseData(tag: "生活费", amount: 7000, color: .red),
        ExpenseData(tag: "学费", amount: 14000, color: .green)
        // 更多周数据...
    ]
    
    let monthData: [ExpenseData] = [
            ExpenseData(tag: "生活费", amount: 30000, color: .red),
            ExpenseData(tag: "学费", amount: 60000, color: .green)
            // 更多月数据...
        ]

        let yearData: [ExpenseData] = [
            ExpenseData(tag: "生活费", amount: 360000, color: .green),
            ExpenseData(tag: "学费", amount: 720000, color: .red)
            // 更多年数据...
        ]


    var body: some View {
        VStack {
            // 时间范围选择器
            HStack {
                Button("当天") { selectedRange = .day }
                Button("7天") { selectedRange = .week }
                Button("30天") { selectedRange = .month }
                Button("年") { selectedRange = .year }
            }

            // 圆形图表
            PieChartView(data: dataForSelectedRange())

            // 总金额
            Text("总金额: \(totalAmountForSelectedRange())")
        }
        .padding()
    }

    private func dataForSelectedRange() -> [ExpenseData] {
        switch selectedRange {
        case .day:
            return dayData
        case .week:
            return weekData
        case .month:
            return monthData
        case .year:
            return yearData
        }
    }

    private func totalAmountForSelectedRange() -> Double {
        dataForSelectedRange().reduce(0) { $0 + $1.amount }
    }
}

enum DateRange {
    case day, week, month, year
}

struct PieChartView: View {
    var data: [ExpenseData]

    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, geometry.size.height)
            let height = width
            let center = CGPoint(x: width / 2, y: height / 2)
            let radius = width / 2

            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    PieSliceView(center: center, radius: radius,
                                 startAngle: angle(for: index, in: data),
                                 endAngle: angle(for: index + 1, in: data),
                                 color: data[index].color,
                                 tag: data[index].tag,
                                 amount: data[index].amount)
                }
            }
            .frame(width: width, height: height)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func angle(for index: Int, in data: [ExpenseData]) -> Angle {
        let total = data.reduce(0) { $0 + $1.amount }
        let sum = data.prefix(index).reduce(0) { $0 + $1.amount }
        return .degrees(sum / total * 360)
    }
}

struct PieSliceView: View {
    var center: CGPoint
    var radius: CGFloat
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    var tag: String
    var amount: Double

    var midAngle: Angle {
        Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
    }

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(color)

            // 在扇区中添加标签和金额
            Text("\(tag): \(amount, specifier: "%.2f")")
                .position(x: center.x + cos(midAngle.radians) * radius / 2, y: center.y + sin(midAngle.radians) * radius / 2)
                .foregroundColor(.white)
        }
    }
}

// 预览提供器
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
