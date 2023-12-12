//
//  TagViewModel.swift
//  SimpleLedger
//

import Foundation
import SwiftUI

class TagViewModel: ObservableObject {
    @Published var tags: [TagModel] = []

    private let store = NSUbiquitousKeyValueStore.default
    private let defaults = UserDefaults.standard
    private let tagsKey = "Tags"

    init() {
        loadTags()
    }

    func addTag(name: String, color: Color) {
        let newTag = TagModel(name: name, color: UIColor(color))
        tags.append(newTag)
        saveTagsToLocal()
        syncTagsToCloud()
    }
    
    func updateTag(id: UUID, newName: String, newColor: UIColor) {
        if let index = tags.firstIndex(where: { $0.id == id }) {
            tags[index].name = newName
            tags[index].color = newColor
            saveTagsToLocal()
            syncTagsToCloud()
        }
    }

    func deleteTag(at offsets: IndexSet) {
        tags.remove(atOffsets: offsets)
        saveTagsToLocal()
        syncTagsToCloud()
    }
    
    func getTagById(withId id: UUID) -> TagModel? {
        return tags.first { $0.id == id }
    }
    
    private func saveTagsToLocal() {
        do {
            let data = try JSONEncoder().encode(tags)
            defaults.set(data, forKey: tagsKey)
        } catch {
            print("Error saving tags to UserDefaults: \(error)")
        }
    }
    
    private func syncTagsToCloud() {
        do {
            let data = try JSONEncoder().encode(tags)
            store.set(data, forKey: "Tags")

            let success = store.synchronize()
            print("-----------")
            print(success)
            if success {
                print("Success to synchronize with iCloud")
            } else {
                print("Failed to synchronize with iCloud")
            }
        } catch {
            print("Error encoding tags: \(error)")
        }
    }


    private func loadTags() {
        if let data = defaults.data(forKey: tagsKey) {
            do {
                tags = try JSONDecoder().decode([TagModel].self, from: data)
                syncTagsToCloud()
            } catch {
                print("Error loading tags from UserDefaults: \(error)")
            }
        }
    }
    
}
