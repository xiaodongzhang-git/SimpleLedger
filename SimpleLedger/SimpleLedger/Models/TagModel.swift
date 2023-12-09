//
//  TagModel.swift
//  SimpleLedger
//

import SwiftUI

struct TagModel: Codable, Identifiable {
    var id = UUID()
    var name: String
    var color: UIColor

    enum CodingKeys: CodingKey {
        case id, name, color
    }

    // 自定义初始化方法来解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let colorData = try container.decode(Data.self, forKey: .color)
        color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) ?? UIColor.black
    }

    // 自定义方法来编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }

    // 初始化方法，供非 Codable 使用
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}

