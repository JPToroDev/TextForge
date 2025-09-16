//
// CDItem+CoreDataClass.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

typealias OrderedItem = (order: Int, object: CDItem)

nonisolated public class CDItem: NSManagedObject {}
