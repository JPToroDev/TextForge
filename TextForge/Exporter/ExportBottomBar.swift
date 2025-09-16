//
// ExportBottomBar.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct ExportBottomBar: View {
    @Environment(\.renderedTemplate) private var renderedTemplate
    private let pasteboard = NSPasteboard.general

    var body: some View {
        HStack {
            Spacer()
            Menu("Copy") {
                Button("Copy As Plain Text", action: copyFilledTemplateAsPlainText)
                Button("Copy As Rich Text", action: copyFilledTemplateAsRichText)
            } primaryAction: {
                copyFilledTemplateAsRichText()
            }
            .keyboardShortcut("c")
            .fixedSize()
        }
        .padding()
    }

    private func copyFilledTemplateAsPlainText() {
        pasteboard.clearContents()
        let nsAttrString = NSAttributedString(renderedTemplate.wrappedValue)
        pasteboard.setString(nsAttrString.string, forType: .string)
    }

    private func copyFilledTemplateAsRichText() {
        pasteboard.clearContents()
        TemplateProcessor.copytoPasteboard(renderedTemplate.wrappedValue)
    }
}

#Preview {
    ExportBottomBar()
}
