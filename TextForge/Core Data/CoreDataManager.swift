//
// CoreDataManager.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData
import SwiftUI

enum CoreDataManager {
    @discardableResult static func createPlaceholder<T: CDPlaceholder>(
        type: T.Type,
        label: String = "",
        template: CDTemplate,
        context: NSManagedObjectContext
    ) -> T {
        let placeholder = T(context: context)
        placeholder.label = label
        placeholder.id = UUID()
        placeholder.template = template
        placeholder.creationDate = Date()
        return placeholder
    }

    @discardableResult static func createTemplate(
        order: Int,
        context: NSManagedObjectContext
    ) -> CDTemplate {
        let template = CDTemplate(context: context)
        template.title = ""
        template.order = order
        template.id = UUID()
        template.modificationDate = Date()
        return template
    }

    @discardableResult static func createMenuOption(
        menu: CDMenu,
        order: Int,
        context: NSManagedObjectContext
    ) -> CDMenuOption {
        let option = CDMenuOption(context: context)
        option.text = ""
        option.id = UUID()
        option.order = order
        option.menu = menu
        return option
    }

    @discardableResult static func createTag(
        order: Int,
        context: NSManagedObjectContext
    ) -> CDTag {
        let tag = CDTag(context: context)
        tag.title = ""
        tag.id = UUID()
        tag.creationDate = Date()
        tag.order = order
        return tag
    }

    static func save(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        try? context.save()
    }

    static func move(items: [any Orderable], from source: IndexSet, to destination: Int) {
        var revisedItems = items
        revisedItems.move(fromOffsets: source, toOffset: destination)

        for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            revisedItems[reverseIndex].order = reverseIndex
        }
    }
}
