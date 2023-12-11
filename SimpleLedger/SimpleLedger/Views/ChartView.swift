//
//  ChartView.swift
//  SimpleLedger
//

import SwiftUI


struct ChartView: View {
    @StateObject private var ledgerModel = LedgerViewModel()
    @StateObject private var tagViewModel = TagViewModel()
    @State private var selectedRange: TimeScope = .today

    var body: some View {
        VStack {
            HStack {
                Button("今天") { selectedRange = .today }
                Button("当月") { selectedRange = .thisMonth }
                Button("今年") { selectedRange = .thisYear }
            }

            // 圆形图表
            PieChartView(data: dataForSelectedRange(), tagViewModel: tagViewModel)

            // 总金额
            Text("总金额: \(totalAmountForSelectedRange())")
        }
        .padding()
    }

    private func dataForSelectedRange() -> [LedgerEntry] {
        switch selectedRange {
        case .today:
            return ledgerModel.getEntries(for: .today)
        case .thisMonth:
            return ledgerModel.getEntries(for: .thisMonth)
        case .thisYear:
            return ledgerModel.getEntries(for: .thisYear)
        }
    }

    private func totalAmountForSelectedRange() -> Double {
        dataForSelectedRange().reduce(0) { $0 + $1.amount }
    }
    
}

struct PieChartView: View {
    var data: [LedgerEntry]
    var tagViewModel: TagViewModel

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
                                 color: Color(getTagModelById(id: data[index].tagID).color),
                                 tag: getTagModelById(id: data[index].tagID).name,
                                 amount: data[index].amount)
                }
            }
            .frame(width: width, height: height)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func angle(for index: Int, in data: [LedgerEntry]) -> Angle {
        let total = data.reduce(0) { $0 + $1.amount }
        let sum = data.prefix(index).reduce(0) { $0 + $1.amount }
        return .degrees(sum / total * 360)
    }
    
    private func getTagModelById(id: UUID) -> TagModel {
        return tagViewModel.getTagById(withId: id) ?? TagModel(name: "默认", color: UIColor(.gray))
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
