//
//  CalendarView.swift
//  SimpleLedger
//


import SwiftUI

struct CalendarView: View {
    
    @State private var selectedDate: Date = Date()
    @State private var showingDetail = false
    @StateObject private var viewModel = LedgerViewModel()
    @StateObject private var tagViewModel = TagViewModel(context: PersistenceController.shared.viewContext)
    @StateObject private var sharedDateModel = SharedDateModel()
    
    var body: some View {
        VStack {
            FSCalendarRepresentable(selectedDate: $sharedDateModel.selectedDate, showingDetail: $showingDetail, viewModel: viewModel)
        }
        .sheet(isPresented: $showingDetail) {
            LedgerDetailView(viewModel: viewModel, tagViewModel: tagViewModel, date: sharedDateModel.selectedDate)
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
                ForEach(viewModel.entries(for: date)) { entry in
                    LedgerEntryRow(entry: entry, tagViewModel: tagViewModel) {
                        // TODO: 实现修改操作
                    } onDelete: {
                        if let recordID = entry.recordID {
                            viewModel.deleteEntry(recordID: recordID)
                        }
                    }
                }
                .onDelete(perform: deleteEntry)
            }
            inputSection
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
            viewModel.addEntry(amount: amount, tagID: selectedTag.id, memo: memoText, date: date)
            
            // 清空输入
            amountText = ""
            memoText = ""
        }
    }
    
    private func deleteEntry(at offsets: IndexSet) {
        offsets.forEach { index in
            let entry = viewModel.entries(for: date)[index]
            if let recordID = entry.recordID {
                viewModel.deleteEntry(recordID: recordID)
            }
        }
    }
}


struct LedgerEntryRow: View {
    var entry: LedgerEntry
    var tagViewModel: TagViewModel
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.memo)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                HStack {
                    Text(entry.amount, format: .currency(code: "USD"))
                        .fontWeight(.bold)
                    Spacer()
                    if let tag = tagViewModel.tags.first(where: { $0.id == entry.tagID }) {
                        Text(tag.name)
                            .padding(5)
                            .background(Color(tag.color))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
            Spacer()
            //            Button(action: onEdit) {
            //                Image(systemName: "pencil.circle")
            //            }
            //            Button(action: onDelete) {
            //                Image(systemName: "trash.circle")
            //            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

