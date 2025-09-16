//
// CDTemplate+CoreDataProperties.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public extension CDTemplate {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDTemplate> {
        NSFetchRequest<CDTemplate>(entityName: "CDTemplate")
    }

    @NSManaged var detail: String
    @NSManaged var isFavorite: Bool
    @NSManaged var modificationDate: Date
    @NSManaged var rawText: String
    @NSManaged var attributedText: NSAttributedString?
    @NSManaged var items: NSSet?
    @NSManaged var tags: NSSet?
}

// MARK: Generated accessors for items

nonisolated public extension CDTemplate {
    @objc(addItemsObject:)
    @NSManaged func addToItems(_ value: CDItem)

    @objc(removeItemsObject:)
    @NSManaged func removeFromItems(_ value: CDItem)

    @objc(addItems:)
    @NSManaged func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged func removeFromItems(_ values: NSSet)
}

// MARK: Generated accessors for tags

nonisolated public extension CDTemplate {
    @objc(addTagsObject:)
    @NSManaged func addToTags(_ value: CDTag)

    @objc(removeTagsObject:)
    @NSManaged func removeFromTags(_ value: CDTag)

    @objc(addTags:)
    @NSManaged func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged func removeFromTags(_ values: NSSet)
}
