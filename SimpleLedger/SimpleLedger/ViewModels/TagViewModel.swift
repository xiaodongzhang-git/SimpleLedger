//
//  TagViewModel.swift
//  SimpleLedger
//

import Foundation
import SwiftUI

class TagViewModel: ObservableObject {
    @Published var tags: [TagModel] = []

    private let store = NSUbiquitousKeyValueStore.default

    init() {
        loadTags()
    }

    func addTag(name: String, color: Color) {
        let newTag = TagModel(name: name, color: UIColor(color))
        tags.append(newTag)
        saveTags()
    }

    private func saveTags() {
        do {
            let data = try JSONEncoder().encode(tags)
            store.set(data, forKey: "Tags")
            store.synchronize()
        } catch {
            print("Error saving tags: \(error)")
        }
    }

    private func loadTags() {
        if let data = store.data(forKey: "Tags") {
            do {
                tags = try JSONDecoder().decode([TagModel].self, from: data)
            } catch {
                print("Error loading tags: \(error)")
            }
        }
    }
    
    func updateTag(id: UUID, newName: String) {
        if let index = tags.firstIndex(where: { $0.id == id }) {
            tags[index].name = newName
            saveTags()
        }
    }

    func deleteTag(at offsets: IndexSet) {
        tags.remove(atOffsets: offsets)
        saveTags()
    }
}
