//
// TemplateProcessor.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

private typealias ParsingOptions = AttributedString.MarkdownParsingOptions

/// A utility class for manipulating and transforming text content.
struct TemplateProcessor {
    /// Converts tokenized text to plain text with placeholder markers.
    /// - Parameter tokenizedText: An NSAttributedString containing tokenized text.
    /// - Returns: A plain string with tokens represented as ◊label◊.
    static func convertToPlainText(_ tokenizedText: NSAttributedString) -> String {
        var string = ""
        let range = NSRange(location: 0, length: tokenizedText.length)
        let options = NSAttributedString.EnumerationOptions(rawValue: 0)
        tokenizedText.enumerateAttributes(in: range, options: options) { object, range, _ in
            if object.keys.contains(NSAttributedString.Key.attachment) {
                if let attachment = object[NSAttributedString.Key.attachment] as? Token,
                   let cell = attachment.attachmentCell as? TokenTextAttachmentCell {
                    string += "◊\(cell.text)◊"
                }
            } else {
                let stringValue: String = tokenizedText.attributedSubstring(from: range).string
                if !stringValue.trimmingCharacters(in: .whitespaces).isEmpty {
                    string += stringValue
                }
            }
        }
        string = string.replacingOccurrences(of: "◊◊", with: "◊ ◊")
        return string
    }

    /// Regenerates template items based on their attributed text.
    /// - Parameters:
    ///   - template: The template whose items should be regenerated.
    ///   - context: The managed object context for Core Data operations.
    static func regenerateItems(in template: CDTemplate, context: NSManagedObjectContext) {
        // Construct a string with placeholders as text and explode
        let attributedText = template.attributedText ?? NSAttributedString()
        let templateString = convertToPlainText(attributedText)
        let splits = templateString.components(separatedBy: "◊")

        // Find and delete existing text items
        let templateItems = template.items?.allObjects as? [CDItem] ?? []
        let templateTexts = templateItems.compactMap { $0 as? CDText }
        templateTexts.forEach { context.delete($0) }

        // Find placeholders and reset their orders
        let templatePlaceholders = templateItems.compactMap { $0 as? CDPlaceholder }
        templatePlaceholders.forEach { $0.orders = [] }

        var index = 0
        let placeholderLabels = templatePlaceholders.map { $0.label }

        // Reorder or build new plain texts
        for phrase in splits where !phrase.isEmpty {
            if placeholderLabels.contains(phrase) {
                // Find existing placeholder and reset its orders
                let placeholder = templatePlaceholders.first { $0.label == phrase }
                let order = CDPlaceholderOrder(context: context)
                order.order = index
                placeholder?.addToOrders(order)
            } else {
                // Create a new text item
                let text = CDText(context: context)
                text.text = phrase
                text.id = UUID()
                text.template = template
                text.order = index
            }
            index += 1
        }

        CoreDataManager.save(context: context)
    }

    /// Converts an array of items to ordered items.
    /// - Parameter items: An array of `CDItem` objects.
    /// - Returns: An array of `OrderedItem` tuples sorted by order.
    nonisolated static func convertToOrderedItems(_ items: [CDItem]) -> [OrderedItem] {
        var itemTuples = [OrderedItem]()

        for case let text as CDText in items {
            let orderedItem = (text.order, text)
            itemTuples.append(orderedItem)
        }

        for case let placeholder as CDPlaceholder in items {
            let orders = placeholder.orders?.allObjects as? [CDPlaceholderOrder] ?? []
            for order in orders {
                let orderedItem = (order.order, placeholder)
                itemTuples.append(orderedItem)
            }
        }

        return itemTuples.sorted(by: { $0.order < $1.order })
    }

    /// Renders a template into rich text.
    /// - Parameter template: The template to render.
    /// - Returns: An `AttributedString` with template's contents.
    static func render(_ template: CDTemplate) -> AttributedString {
        let options = ParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        let accentAttributes = AttributeContainer([.foregroundColor: NSColor(Color.accentColor)])
        var finalString = AttributedString()

        for item in template.orderedItems {
            guard let markdown = textRepresentation(for: item.object),
                  var attributedString = try? AttributedString(markdown: markdown, options: options)
            else { continue }

            if !(item.object is CDText) {
                attributedString.setAttributes(accentAttributes)
            }

            finalString.append(attributedString)
        }

        return finalString
    }

    /// Generates a plain text representation of a template.
    /// - Parameter template: The template to convert.
    /// - Returns: A string representation with placeholders marked delimited by `◊...◊`.
    static func generateRawText(_ template: CDTemplate) -> String {
        template.orderedItems.reduce(into: "") { result, item in
            switch item.object {
            case let text as CDText:
                result += text.text
            case let placeholder as CDPlaceholder:
                result += "◊\(placeholder.label)◊"
            default:
                break
            }
        }
    }

    /// Copies an attributed string to the system pasteboard in RTF format.
    /// - Parameter attrString: The `AttributedString` to copy.
    static func copytoPasteboard(_ attrString: AttributedString) {
        let newString = style(attrString)
        let attributedString = NSAttributedString(newString)

        do {
            let rtfData = try attributedString.data(
                from: NSRange(location: 0, length: attributedString.length),
                documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
            NSPasteboard.general.setData(rtfData, forType: .rtf)
        } catch {
            print("Error creating RTF from AttributedString. Please file a bug report.")
        }
    }

    /// Retrieves the plain text representation of a template item.
    /// - Parameter item: The `CDItem` to extract text from.
    /// - Returns: The text representation, or `nil` if none exists.
    private static func textRepresentation(for item: CDItem) -> String? {
        switch item {
        case let text as CDText:
            return text.text
        case let textField as CDTextField where !textField.text.isEmpty:
            return textField.text
        case let menu as CDMenu:
            let options = menu.options?.allObjects as? [CDMenuOption] ?? []
            let selectedText = options.first(where: { $0.order == menu.selection })?.text
            return selectedText
        case let checkbox as CDCheckbox where checkbox.isChecked:
            return checkbox.text
        default: return nil
        }
    }

    /// Applies styling to an attributed string based on user preferences.
    /// - Parameter attrString: The AttributedString to style.
    /// - Returns: A styled AttributedString.
    private static func style(_ attrString: AttributedString) -> AttributedString {
        let userDefaults = UserDefaults.standard
        let fontSize = userDefaults.double(forKey: .richTextFontSize)
        let richFontName = userDefaults.string(forKey: .richTextFont) ?? K.defaultRichTextFont
        let monoFontName = userDefaults.string(forKey: .monospacedFont) ?? K.defaultMonospacedFont

        guard let regularFont = NSFont(name: richFontName, size: fontSize),
              let monoFont = NSFont(name: monoFontName, size: fontSize)
        else {
            fatalError("Unable to construct fonts. Please file a bug report.")
        }

        let accentContainer = AttributeContainer([.foregroundColor: NSColor.accent, .font: regularFont])
        let plainContainer = AttributeContainer([.foregroundColor: NSColor.labelColor, .font: regularFont])
        let fontManager = NSFontManager.shared

        var newString = attrString
        let runs = newString.runs

        for run in runs {
            let range = run.range

            if run.link != nil {
                newString[range].mergeAttributes(accentContainer)
                continue
            }

            newString[range].setAttributes(plainContainer)
            guard let textStyle = run.inlinePresentationIntent else { continue }

            switch textStyle.rawValue {
            case 1: // italicized
                let nsFont = fontManager.convert(regularFont, toHaveTrait: .italicFontMask)
                let container = AttributeContainer([.font: nsFont])
                newString[range].setAttributes(container)
            case 2: // bold
                let nsFont = fontManager.convert(regularFont, toHaveTrait: .boldFontMask)
                let container = AttributeContainer([.font: nsFont])
                newString[range].setAttributes(container)
            case 3: // bold-italic
                let nsFont = fontManager.convert(regularFont, toHaveTrait: [.boldFontMask, .italicFontMask])
                let container = AttributeContainer([.font: nsFont])
                newString[range].setAttributes(container)
            case 4: // code
                let container = AttributeContainer([.font: monoFont])
                newString[range].setAttributes(container)
            case 32: // strikethrough
                newString[range].strikethroughStyle = .single
            default: break
            }
        }

        return newString
    }
}
