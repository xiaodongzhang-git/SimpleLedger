//
//  TagView.swift
//  SimpleLedger
//

import SwiftUI

struct TagView: View {
    @StateObject private var viewModel = TagViewModel(context: PersistenceController.shared.viewContext)
    @State private var newTagName = ""
    @State private var selectedColor: Color = .gray
    @State private var editingTagID: UUID? = nil
    @State private var tempTagName = ""
    @State private var tempTagColor: UIColor = .gray

    var body: some View {
        VStack {
            Text("创建新标签")
                .font(.headline)

            // 新标签输入
            TextField("输入标签名称", text: $newTagName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // 颜色选择器
            ColorPicker("选择颜色", selection: $selectedColor, supportsOpacity: false)
                .padding()

            // 创建按钮
            Button("创建标签") {
                viewModel.addTag(name: newTagName, color: selectedColor)
                newTagName = "" // 重置输入
            }
            .disabled(newTagName.isEmpty || isColorUsed(selectedColor))

            Divider()

            // 显示已创建的标签
            List {
                ForEach(viewModel.tags) { tag in
                    HStack {
                        if editingTagID == tag.id {
                            // 编辑状态
                            TextField("编辑标签", text: $tempTagName)
                            ColorPicker("选择颜色", selection: Binding(get: {
                                                            Color(tempTagColor)
                                                        }, set: { newColor in
                                                            tempTagColor = UIColor(newColor)
                                                        }), supportsOpacity: false)

                                                        Spacer()
                            Spacer()
                            Button(action: {
                                viewModel.updateTag(id: tag.id, newName: tempTagName, newColor: tempTagColor)
                                editingTagID = nil
                            }) {
                                Image(systemName: "checkmark")
                            }
                        } else {
                            // 常规显示
                            Text(tag.name)
                            Spacer()
                            Circle()
                                .fill(Color(uiColor: UIColorHelper.fromString(hexString: tag.color)))
                                .frame(width: 24, height: 24)

                            // 编辑按钮
                            Button(action: {
                                tempTagName = tag.name
                                editingTagID = tag.id
                            }) {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteTag)
            }
        }
        .padding()
    }

    // 检查颜色是否已被使用
    private func isColorUsed(_ color: Color) -> Bool {
        let uiColor = UIColor(color)
        return viewModel.tags.contains { UIColorHelper.fromString(hexString: $0.color) == uiColor }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
