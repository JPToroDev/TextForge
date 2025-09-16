//
// CDMenu+CoreDataClass.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import CoreData

nonisolated public class CDMenu: CDPlaceholder {
    var orderedOptions: [CDMenuOption] {
        let options = options?.allObjects as? [CDMenuOption] ?? []
        return options.sorted(by: { $0.order < $1.order })
    }
}
