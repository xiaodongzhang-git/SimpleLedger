//
//  TagView.swift
//  SimpleLedger
//
//  Created by xiaodong zhang on 2023/12/06.
//

import SwiftUI

struct TagData {
    var name: String
    var color: Color
}

struct TagView: View {
    @State private var newTagName = ""
    @State private var selectedColor: Color = .gray
    @State private var tags: [TagData] = []
    let availableColors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink, .brown, .cyan, .mint]

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
                addTag(name: newTagName, color: selectedColor)
                newTagName = "" // 重置输入
            }
            .disabled(newTagName.isEmpty || isColorUsed(selectedColor))

            Divider()

            // 显示已创建的标签
            List {
                ForEach(tags, id: \.name) { tag in
                    HStack {
                        Text(tag.name)
                        Spacer()
                        Circle()
                            .fill(tag.color)
                            .frame(width: 24, height: 24)
                    }
                }
                .onDelete(perform: deleteTag)
            }

            Spacer()
        }
        .padding()
    }

    // 添加新标签
    private func addTag(name: String, color: Color) {
        let newTag = TagData(name: name, color: color)
        tags.append(newTag)
    }

    // 删除标签
    private func deleteTag(at offsets: IndexSet) {
        tags.remove(atOffsets: offsets)
    }

    // 检查颜色是否已被使用
    private func isColorUsed(_ color: Color) -> Bool {
        tags.contains { $0.color == color }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}

