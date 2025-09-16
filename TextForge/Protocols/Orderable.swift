//
// Orderable.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated protocol Orderable: NSManagedObject {
    var order: Int { get set }
}
