//
//  CalendarView.swift
//  SimpleLedger
//


import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var showingDetail = false
    @StateObject private var viewModel = LedgerViewModel()
    @StateObject private var tagViewModel = TagViewModel()

    var body: some View {
        VStack {
            FSCalendarRepresentable(selectedDate: $selectedDate, showingDetail: $showingDetail)
            Button("") {
                showingDetail = true
            }
        }
        .sheet(isPresented: $showingDetail) {
            LedgerDetailView(viewModel: viewModel,
                tagViewModel: tagViewModel,
                             date: selectedDate)
        }
    }
}

struct LedgerDetailView: View {
    @ObservedObject var viewModel: LedgerViewModel
    @ObservedObject var tagViewModel: TagViewModel
    var date: Date

    @State private var selectedTagIndex: Int = 0
    @State private var amountText: String = ""
    @State private var memoText: String = ""

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.getEntriesByDate(for: date)) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.tagName)
                            .foregroundColor(entry.tagColor)
                        Text(String(format: "%.2f", entry.amount))
                        Text(entry.memo)
                    }
                }
                // 用于输入新账目的区域
                inputSection
            }
        }
    }

    private var inputSection: some View {
        Group {
            // 标签选择
            Picker("选择标签", selection: $selectedTagIndex) {
                ForEach(0..<tagViewModel.tags.count, id: \.self) { index in
                    Text(tagViewModel.tags[index].name).tag(index)
                }
            }

            // 金额输入
            TextField("金额", text: $amountText)
                .keyboardType(.decimalPad)

            // 备注输入
            TextField("备注", text: $memoText)

            // 保存按钮
            Section {
                Button("保存") {
                    saveEntry()
                }
                .disabled(!isSaveButtonEnabled)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSaveButtonEnabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
        }
    }
    
    private var isSaveButtonEnabled: Bool {
        guard !tagViewModel.tags.isEmpty,
              selectedTagIndex >= 0 && selectedTagIndex < tagViewModel.tags.count,
              let _ = Double(amountText), !amountText.isEmpty else {
            return false
        }
        return true
    }

    private func saveEntry() {
        if let amount = Double(amountText), selectedTagIndex >= 0 && selectedTagIndex < tagViewModel.tags.count {
            let selectedTag = tagViewModel.tags[selectedTagIndex]
            print("Selected Date: \(date)")
            print("Selected Tag: \(selectedTag)")
            print("Amount: \(amount)")
            print("Memo: \(memoText)")

            // 添加到 LedgerViewModel
            // viewModel.addEntry(amount: amount, tagID: selectedTag.id, tagName: selectedTag.name, tagColor: selectedTag.color, memo: memoText, date: date)

            // 清空输入
            amountText = ""
            memoText = ""
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

