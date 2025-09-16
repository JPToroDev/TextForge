//
// CDTemplate+CoreDataClass.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public class CDTemplate: CDObject {
    var placeholders: [CDPlaceholder] {
        let items = items?.allObjects as? [CDItem] ?? []
        let placeholders = items.filter { $0 is CDPlaceholder } as? [CDPlaceholder] ?? []
        let placeholdersByCreation = placeholders.sorted(by: { $0.creationDate < $1.creationDate })
        return placeholdersByCreation
    }

    var orderedItems: [OrderedItem] {
        let itemsArray = items?.allObjects as? [CDItem] ?? []
        let orderedItems = TemplateProcessor.convertToOrderedItems(itemsArray)
        return orderedItems
    }
}

nonisolated extension CDTemplate: Orderable {}
