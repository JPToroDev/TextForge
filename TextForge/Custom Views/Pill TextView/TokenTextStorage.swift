//
// TokenTextStorage.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import AppKit

nonisolated class TokenTextStorage: NSTextStorage {
    /// The backing store of the token text storage object.
    /// Use a `NSTextStorage` instance because it does some additional performance
    /// optimizations over `NSMutableAttributedString`.
    let store = NSTextStorage()

    /// Whether the tokens are stale and need to be refreshed
    /// before access to `tokens`.
    private var areTokensDirty: Bool = true

    /// The dictionary caching a token and its character
    /// index within the storage.
    private var cachedTokens: [Token: Int] = [:]

    /// The dictionary mapping a token to its character index
    /// within the storage.
    /// - Note: Remember a dictionary's order is unpredictable;
    /// thus, no presumption of order should be made.
    var tokens: [Token: Int] {
        guard areTokensDirty else { return cachedTokens }
        cachedTokens.removeAll()
        store.enumerateAttribute(
            .attachment,
            in: NSRange(location: 0, length: store.length),
            options: .longestEffectiveRangeNotRequired
        ) { attachment, range, _ in
            guard let token = attachment as? Token else { return }
            cachedTokens[token] = range.location
        }
        areTokensDirty = false
        return cachedTokens
    }

    /// Whether the receiver contains any tokens.
    public var hasTokens: Bool {
        !tokens.isEmpty
    }

    /// Returns the token at a specified character index.
    /// - Parameter characterIndex: The character index.
    /// - Returns: The token at `characterIndex`, or nil if non-existent.
    func token(at characterIndex: Int) -> Token? {
        guard characterIndex >= 0 && characterIndex < length else { return nil }
        return attribute(.attachment, at: characterIndex, effectiveRange: nil) as? Token
    }

    /// Returns the token at a range.
    /// - Parameter range: The range of the token.
    /// - Returns: The `Token` perfectly enclosed by `range`, or `nil`.
    /// - Note: Only returns a non-nil value when the range is the _exact_
    /// location and length of token, **not** a token _within_ the range.
    func token(at range: NSRange) -> Token? {
        guard range.length == 1, range.upperBound <= length else { return nil }
        return token(at: range.location)
    }

    /// Returns the character index of a specified token.
    /// - Parameter token: The token.
    /// - Returns: The character index of `token`, or `nil` if it is not in the text.
    func characterIndex(of token: Token) -> Int? {
        return tokens[token]
    }

    /// Returns the character range of a specified token.
    /// - Parameter token: The token.
    /// - Returns: The character range of `token`, or `nil` if it is not in the text.
    func characterRange(of token: Token) -> NSRange? {
        guard let characterIndex = characterIndex(of: token)
        else { return nil }
        return NSRange(location: characterIndex, length: 1)
    }

    /// Deletes the specified token from the receiver.
    /// - Parameter characterIndex: The character index of the token to delete from the receiver.
    /// - Note: This method does not support undo/redo operations.
    func deleteToken(at characterIndex: Int) {
        deleteCharacters(in: NSRange(location: characterIndex, length: 1))
    }
}

// MARK: - Subclass Primitive Methods

nonisolated extension TokenTextStorage {
    override open var string: String {
        return store.string
    }

    override open func attributes(
        at location: Int,
        effectiveRange range: NSRangePointer?
    ) -> [NSAttributedString.Key: Any] {
        return store.attributes(at: location, effectiveRange: range)
    }

    override open func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        store.removeAttribute(.attachment, range: range)
        store.replaceCharacters(in: range, with: str)
        // Note: Casting to NSString is necessary for unicode characters (mostly emojis).
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
        areTokensDirty = true
        endEditing()
    }

    override open func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
        beginEditing()
        store.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        areTokensDirty = true
        endEditing()
    }
}

extension TokenTextStorage {
    /// Returns the "closest" token to a specified character index
    /// (searching towards the end of the string). Optionally, providing an
    /// offset that will begin the search backwards by that amount
    /// (or the beginning of the string if out of bounds). Looping
    /// will search for the first token in the entire text view if none exist
    /// within the aforementioned range.
    ///
    /// - Parameters:
    ///    - characterIndex: The character index to search from.
    ///    - offset: The offset to subtract from `characterIndex` before searching. Defaults to `3`.
    ///    - shouldLoop: Whether the search should cycle back to the beginning of the receiver
    ///    if no other pills exist to the end of the string.
    ///  - Returns: The "closest" token to a specified character index, or nil if no such tokens exist.
    func closestToken(to characterIndex: Int, offset: Int = 3, shouldLoop: Bool = true) -> Token? {
        let startingIndex = max(0, characterIndex - offset)
        let toEndRange = NSRange(location: startingIndex, length: length - startingIndex)
        let endToken = firstToken(in: toEndRange)
        // If already found token OR don't want to loop, return result or nil.
        if endToken != nil || !shouldLoop {
            return endToken
        }
        // Otherwise, search from the beginning.
        let fromStartRange = NSRange(location: 0, length: length - toEndRange.length)
        return firstToken(in: fromStartRange)
    }

    /// Returns the next token after a specified token. Optionally, cycling
    /// back to the very first token if none exist after the specified token.
    ///
    /// - Parameters:
    ///    - token: The point-of-reference token.
    ///    - shouldLoop: Whether the search should cycle back to the
    ///     first token if no other tokens exist to the end of the string.
    ///  - Returns: The token after a specified token, or `nil` if no other tokens exist.
    func tokenFollowing(_ token: Token, shouldLoop: Bool = true) -> Token? {
        guard tokens.count > 1, let characterIndex = characterIndex(of: token) else { return nil }
        let sortedTokens = tokens.sorted { $0.value < $1.value }

        return if let followingToken = sortedTokens.first(where: { $0.value > characterIndex }) {
            followingToken.key
        } else if shouldLoop {
            sortedTokens.first?.key
        } else {
            nil
        }
    }
}

private extension TokenTextStorage {
    /// Returns the first token in a specified range.
    /// - Parameter characterRange: The character range to search within.
    /// - Returns: The first token in `characterRange`, or `nil` if no such token exists.
    func firstToken(in characterRange: NSRange) -> Token? {
        guard hasTokens else { return nil }

        var firstToken: Token?
        enumerateAttribute(
            .attachment,
            in: characterRange,
            options: .longestEffectiveRangeNotRequired
        ) { attachment, _, shouldStop in
            guard let token = attachment as? Token else { return }
            shouldStop.pointee = true
            firstToken = token
        }

        return firstToken
    }
}
