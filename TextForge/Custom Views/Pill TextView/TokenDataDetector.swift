//
// TokenDataDetector.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import Cocoa

nonisolated class TokenDataDetector: NSRegularExpression, @unchecked Sendable {
    /// The application's shared token data detector initialized with the `tokenRegex` pattern.
    static let shared = TokenDataDetector()

    /// The regular expression pattern used by the shared token data detector.
    private static let regexPattern = "◊(.*?)◊"

    convenience init() {
        do {
            try self.init(pattern: Self.regexPattern)
        } catch {
            fatalError("Failed to initialize TokenDataDetector: \(error)")
        }
    }

    /// Parse and replace plaintext tokens in a string using the `shared` token data detector.
    /// - Parameter string: The string to parse tokens out of.
    /// - Returns: A mutable attributed string containing `Token`s and any remaining original text.
    @MainActor static func tokenize(string: String) -> NSMutableAttributedString {
        shared.tokenize(string: string)
    }

    /// Parse and replace plaintext tokens in a string.
    /// - Parameter string: The string to tokens tokens out of.
    /// - Returns: A mutable attributed string containing `Token`s and any remaining original text.
    @MainActor private func tokenize(string: String) -> NSMutableAttributedString {
        var tokenData = [(range: NSRange, token: Token)]()
        let attributes: [NSAttributedString.Key: AnyObject] = [
            .foregroundColor: NSColor.labelColor,
            .font: NSFont.preferredFont(forTextStyle: .body)
        ]

        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes)
        enumerateMatches(in: string, range: mutableAttributedString.contentRange, using: replace)

        for token in tokenData.reversed() {
            mutableAttributedString.replaceCharacters(in: token.range, with: token.token.attributedStringValue)
        }

        return mutableAttributedString

        func replace(
            _ result: NSTextCheckingResult?,
            _ flags: NSRegularExpression.MatchingFlags,
            _ shouldStop: UnsafeMutablePointer<ObjCBool>
        ) {
            let nsString = string as NSString
            let token = Token(text: nsString.substring(with: result!.range(at: 1)))
            tokenData.append((result!.range, token))
        }
    }
}
