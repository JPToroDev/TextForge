//
// TokenizedTextView.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import AppKit

final class TokenizedTextView: NSTextView {
    /// The strong referenced token text storage object,
    /// accessible from the `textStorage` property.
    let tokenTextStorage = TokenTextStorage()

    /// The token layout manager object,
    /// accessible from the `layoutManager` property.
    private let tokenLayoutManager = TokenLayoutManager()

    /// The currently focused token in the text view.
    var selectedToken: Token?

    /// Whether a token is currently focused.
    var hasSelectedToken: Bool {
        selectedToken != nil
    }

    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    private func commonInit() {
        textContainer?.replaceLayoutManager(tokenLayoutManager)
        layoutManager?.replaceTextStorage(tokenTextStorage)
    }
}

extension TokenizedTextView {
    /// Returns the token falling under the given point, expressed in the text view's coordinate system.
    /// - Parameter point: The point for which to return the token, in coordinates of the text view.
    /// - Returns: The token falling under the given point, expressed in the text view's coordinate system.
    func token(at point: NSPoint) -> Token? {
        let pointInTextContainer = convertToTextContainer(point)
        guard let characterIndex = tokenLayoutManager
            .characterIndex(for: pointInTextContainer, in: textContainer!)
        else { return nil }
        return tokenTextStorage.token(at: characterIndex)
    }

    /// Selects the given token, deselecting a currently selected one,
    /// redrawing involved tokens with appropriate highlighting.
    /// - Parameter token: The token to select.
    func select(_ token: Token) {
        guard token != selectedToken else { return }

        // First unhighlight all tokens
        for location in 0..<(textStorage?.length ?? 0) {
            if let existingToken = tokenTextStorage.token(at: location) {
                highlight(existingToken, flag: false)
            }
        }

        deselectSelectedToken()
        selectedTextAttributes = [NSAttributedString.Key.backgroundColor: NSColor.clear]
        highlight(token, flag: true)
        selectedToken = token

        guard let characterIndex = tokenTextStorage.characterIndex(of: token) else { return }
        setSelectedRange(NSRange(location: characterIndex, length: 1))
    }

    /// Deselects the selected token, if there is one.
    func deselectSelectedToken() {
        guard let selectedToken else { return }
        highlight(selectedToken, flag: false)
        selectedTextAttributes = [NSAttributedString.Key.backgroundColor: NSColor.selectedTextBackgroundColor]
        self.selectedToken = nil
    }

    /// Replaces the token with an empty string.
    /// - Parameter token: The token to replace.
    func delete(_ token: Token) {
        guard let characterRange = tokenTextStorage.characterRange(of: token) else { return }
        selectedToken = nil
        shouldChangeText(in: characterRange, replacementString: "")
        tokenTextStorage.deleteToken(at: characterRange.location)
        didChangeText()
        setSelectedRange(NSRange(location: characterRange.location, length: 0))
    }
}

// MARK: - Text Selection

extension TokenizedTextView {
    override func setSelectedRange(
        _ charRange: NSRange,
        affinity: NSSelectionAffinity,
        stillSelecting stillSelectingFlag: Bool
    ) {
        // If there's a single token at the selection point, select it
        if charRange.length == 1, let selectedToken = tokenTextStorage.token(at: charRange) {
            select(selectedToken)
        } else {
            // For multi-character selections, deselect any currently selected token
            deselectSelectedToken()

            // If the selection range includes any tokens, highlight them
            if charRange.length > 0 {
                for location in charRange.location..<(charRange.location + charRange.length) {
                    if let token = tokenTextStorage.token(at: location) {
                        highlight(token, flag: true)
                    }
                }
            } else {
                // If selection is cleared, unhighlight any previously highlighted tokens
                for location in 0..<(textStorage?.length ?? 0) {
                    if let token = tokenTextStorage.token(at: location) {
                        highlight(token, flag: false)
                    }
                }
            }
        }

        super.setSelectedRange(charRange, affinity: affinity, stillSelecting: stillSelectingFlag)
    }
}

// MARK: - Responder

extension TokenizedTextView {
    private func moveHorizontally(range: NSRange, offset: Int = 0) -> Bool {
        if hasSelectedToken {
            // There's a selected token, so deselect it and call super
            // (which will move the insertion point to correct side of the token).
            // Note: There may be a neighboring token, so we need
            // to check this case before the next one.
            deselectSelectedToken()
        } else if range.length == 0, let token = tokenTextStorage.token(at: range.location + offset) {
            // No current selection and bordering a token, so just select it.
            select(token)
            return false
        } else {
            deselectSelectedToken()
        }

        return true
    }

    override func moveLeft(_ sender: Any?) {
        let currentSelectedRange = selectedRange()
        /// Use an offset of -1 to check if the previous character is a token
        let callSuper = moveHorizontally(range: currentSelectedRange, offset: -1)
        guard callSuper else { return }
        super.moveLeft(sender)
    }

    override func moveRight(_ sender: Any?) {
        let currentSelectedRange = selectedRange()
        let callSuper = moveHorizontally(range: currentSelectedRange)
        guard callSuper else { return }
        super.moveRight(sender)
    }

    override func mouseDown(with event: NSEvent) {
        guard let token = token(at: convert(event.locationInWindow, from: nil)) else {
            deselectSelectedToken()
            return super.mouseDown(with: event)
        }

        guard token != selectedToken else { return }
        select(token)
    }

    override func insertTab(_ sender: Any?) {
        guard let selectedToken else {
            return if let closestToken = tokenTextStorage.closestToken(to: selectedRange().location) {
                select(closestToken)
            } else {
                super.insertTab(sender)
            }
        }

        guard let nextToken = tokenTextStorage.tokenFollowing(selectedToken) else { return }
        select(nextToken)
    }

    override func insertNewline(_ sender: Any?) {
        guard selectedToken == nil else { return }
        super.insertNewline(sender)
    }

    override func deleteBackward(_ sender: Any?) {
        if let selectedToken {
            delete(selectedToken)
        } else {
            super.deleteBackward(sender)
        }
    }
}

private extension TokenizedTextView {
    /// Calls the necessary methods to redraw the specified token as highlighted or unhighlighted.
    /// - Parameters:
    ///   - token: The token that will be redrawn.
    ///   - flag: When `true`, redraws the token as highlighted; otherwise, redraws it normally.
    func highlight(_ token: Token, flag: Bool) {
        guard let characterRange = tokenTextStorage.characterRange(of: token),
              let cell = token.attachmentCell
        else { return }
        cell.highlight(flag, withFrame: token.bounds, in: self)
        tokenLayoutManager.invalidateDisplay(forCharacterRange: characterRange)
    }
}
