//
//  TagViewModel.swift
//  SimpleLedger
//

import Foundation
import SwiftUI
import CoreData

class TagViewModel: ObservableObject {
    @Published var tags: [TagEntryMo] = []
    
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadTags()
    }

    func addTag(name: String, color: Color) {
        let newTag = TagEntryMo(context: viewContext)
        newTag.id = UUID()
        newTag.name = name
        newTag.color = UIColorHelper.toString(color: UIColor(color))

        saveContext()
        loadTags()
    }
    
    func updateTag(id: UUID, newName: String, newColor: UIColor) {
        if let tag = tags.first(where: { $0.id == id }) {
            tag.name = newName
            tag.color = UIColorHelper.toString(color: newColor)
            saveContext()
            loadTags()
        }
    }

    func deleteTag(at offsets: IndexSet) {
        offsets.forEach { index in
            let tag = tags[index]
            viewContext.delete(tag)
        }
        saveContext()
        loadTags()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    private func loadTags() {
        let request: NSFetchRequest<TagEntryMo> = TagEntryMo.fetchRequest()
        do {
            tags = try viewContext.fetch(request)
        } catch {
            print("Error fetching tags: \(error)")
        }
    }
    
    func getTagById(withId id: UUID) -> TagEntryMo {
        if let tag = tags.first(where: { $0.id == id }) {
            return tag
        }else{
            let tagMo = TagEntryMo()
            tagMo.id = UUID()
            tagMo.name = "默认"
            tagMo.color = UIColorHelper.toString(color: UIColor.gray)
            return tagMo
        }
    }
}
