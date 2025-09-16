//
// Token.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import AppKit

nonisolated class Token: NSTextAttachment {
    /// The attributed string containing the token as an attachment.
    var attributedStringValue: NSAttributedString {
        NSAttributedString(attachment: self)
    }

    @MainActor init(text: String) {
        super.init(data: nil, ofType: nil)
        self.attachmentCell = TokenTextAttachmentCell(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
