//
// TokenTextAttachmentCell.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import AppKit

class TokenTextAttachmentCell: NSTextAttachmentCell {
    let text: String
    private let horizontalPadding = 4.0
    private let cornerRadius = 4.0

    override func draw(
        withFrame cellFrame: NSRect,
        in controlView: NSView?,
        characterIndex charIndex: Int,
        layoutManager: NSLayoutManager
    ) {
        let glyphIndex = layoutManager.glyphIndexForCharacter(at: charIndex)
        var tokenFrame = cellFrame
        calculateTokenFrame()
        drawToken()
        drawText()

        func calculateTokenFrame() {
            let lineFragmentRect = layoutManager.lineFragmentRect(
                forGlyphAt: glyphIndex,
                effectiveRange: nil,
                withoutAdditionalLayout: true)
            guard let textContainer = layoutManager.textContainer(
                forGlyphAt: glyphIndex,
                effectiveRange: nil)
            else { return }
            let boundingRect = layoutManager.boundingRect(
                forGlyphRange: .init(location: glyphIndex, length: 1),
                in: textContainer)
            tokenFrame.origin.y += boundingRect.height - lineFragmentRect.height
        }

        func drawToken() {
            let tokenPath = NSBezierPath(roundedRect: tokenFrame, xRadius: cornerRadius, yRadius: cornerRadius)
            (isHighlighted ? NSColor.systemGray : NSColor.systemOrange).setFill()
            tokenPath.fill()
        }

        func drawText() {
            let string = NSMutableAttributedString(string: text)
            string.addAttribute(.foregroundColor, value: NSColor.white, range: string.contentRange)
            let typesetter = layoutManager.typesetter
            let baselineOffset = typesetter.baselineOffset(in: layoutManager, glyphIndex: glyphIndex)
            let textSize = string.size()
            let xValue = tokenFrame.midX - textSize.width / 2
            let yValue = tokenFrame.maxY - baselineOffset - 0.75
            let textOrigin = NSPoint(x: xValue, y: yValue)
            string.draw(with: NSRect(origin: textOrigin, size: .zero))
        }
    }

    nonisolated override func cellSize() -> NSSize {
        let string = NSMutableAttributedString(string: text)
        let font = NSFont.preferredFont(forTextStyle: .body)
        string.addAttribute(.font, value: font, range: string.contentRange)
        var size = string.size()
        size.width += 2 * horizontalPadding
        return size
    }

    nonisolated override func cellBaselineOffset() -> NSPoint {
        let descenderHeight = NSFont.preferredFont(forTextStyle: .body).descender
        return NSPoint(x: 0, y: floor(descenderHeight))
    }

    init(text: String) {
        self.text = text
        super.init()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
