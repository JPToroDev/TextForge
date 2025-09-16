//
// NSAttributedString.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import Foundation

nonisolated extension NSAttributedString {
    /// Returns the character range of the entire string.
    var contentRange: NSRange {
        NSRange(location: 0, length: length)
    }
}
