//
// TokenLayoutManager.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import AppKit

nonisolated class TokenLayoutManager: NSLayoutManager {
    /// Returns the index of the character falling under the given point,
    /// expressed in the given container's coordinate system.
    /// - Parameters:
    ///   - point: The point for which to return the character index,
    ///   in coordinates of `textContainer`.
    ///   - textContainer: The container in which the returned
    ///   character index is laid out.
    /// - Returns: The index of the character falling under the given point,
    /// expressed in the given container's coordinate system.
    func characterIndex(for point: NSPoint, in textContainer: NSTextContainer) -> Int? {
        let nearestIndex = glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: nil)
        // Check to see whether the mouse actually lies over the glyph it is nearest to.
        let glyphRect = boundingRect(forGlyphRange: NSRange(location: nearestIndex, length: 1), in: textContainer)
        guard glyphRect.contains(point) else { return nil }
        return characterIndexForGlyph(at: nearestIndex)
    }
}
