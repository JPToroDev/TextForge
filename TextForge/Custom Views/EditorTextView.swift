//
// EditorTextView.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct EditorTextView: NSViewRepresentable {
    @ObservedObject var template: CDTemplate
    @Binding var placeholderCode: String?

    private let tokenizedTextView = TokenizedTextView.scrollableTextView()

    func makeCoordinator() -> Coordinator {
        Coordinator(template: template)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let font = NSFont.preferredFont(forTextStyle: .body)
        // swiftlint:disable:next force_cast
        let textView = tokenizedTextView.documentView as! TokenizedTextView
        textView.delegate = context.coordinator
        textView.allowsUndo = true
        textView.isContinuousSpellCheckingEnabled = true
        textView.textContainerInset = NSSize(width: 10, height: 15)
        textView.font = font
        textView.string = template.rawText

        pillify(textView: textView)

        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineSpacing = 1
        textView.defaultParagraphStyle = mutableParagraphStyle

        textView.typingAttributes = [
            .font: font,
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: mutableParagraphStyle
        ]

        Task { @MainActor in
            template.attributedText = textView.attributedString()
        }

        return tokenizedTextView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let placeholderCode else { return }
        // swiftlint:disable:next force_cast
        let textView = nsView.documentView as! TokenizedTextView
        let insertionPointIndex = textView.selectedRanges.first?.rangeValue.location

        guard let insertionPointIndex else { return }
        let range = NSRange(location: insertionPointIndex, length: 0)
        let pill = TokenDataDetector.tokenize(string: placeholderCode)
        textView.insertText(pill, replacementRange: range)

        Task.detached {
            await MainActor.run {
                self.placeholderCode = nil
            }
        }
    }

    // Parses the string's pills and sets the result to the text view.
    @MainActor private func pillify(textView: TokenizedTextView) {
        guard let storage = textView.textStorage as? TokenTextStorage else { return }
        let string = TokenDataDetector.tokenize(string: textView.string)
        storage.setAttributedString(string)
    }
}

extension EditorTextView {
    @MainActor
    class Coordinator: NSObject, NSTextViewDelegate {
        fileprivate init(template: CDTemplate) {
            self.template = template
        }

        @ObservedObject private var template: CDTemplate

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? TokenizedTextView else { return }
            Task { @MainActor in
                template.attributedText = textView.attributedString()
            }
        }

        func textView(
            _ textView: NSTextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementString: String?
        ) -> Bool {
            true
        }
    }
}
