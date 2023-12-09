//
//  LedgerDetailView.swift
//  SimpleLedger
//
//  Created by xiaodong zhang on 2023/12/09.
//

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
                    HStack {
                        if let tag = tagViewModel.tags.first(where: { $0.id == entry.tagID }) {
                            Text(tag.name)
                                .foregroundColor(Color(tag.color))
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(String(format: "%.2f", entry.amount))
                                Text(entry.memo)
                            }
                        }
                    }
                    .padding()
                }
                .listRowBackground(Color.clear)

                inputSection
            }
            .listStyle(PlainListStyle())
        }
    }

    private var inputSection: some View {
        Group {
            Picker("选择标签", selection: $selectedTagIndex) {
                ForEach(0..<tagViewModel.tags.count, id: \.self) { index in
                    Text(tagViewModel.tags[index].name).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            TextField("金额", text: $amountText)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            TextField("备注", text: $memoText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

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
        .padding(.horizontal)
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
            viewModel.addEntry(amount: amount, tagID: selectedTag.id, memo: memoText, date: date)
            amountText = ""
            memoText = ""
        }
    }
}
