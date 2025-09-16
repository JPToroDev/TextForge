//
// NSTextView.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import AppKit

extension NSTextView {
    override open var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}

extension NSTextView {
    /// Converts a point from the coordinate system of the text view to that of the text container view.
    /// - Parameter point: A point specifying a location in the coordinate system of text view.
    /// - Returns: The point converted to the coordinate system of the text view's text container.
    func convertToTextContainer(_ point: NSPoint) -> NSPoint {
        NSPoint(x: point.x - textContainerOrigin.x, y: point.y - textContainerOrigin.y)
    }
}
