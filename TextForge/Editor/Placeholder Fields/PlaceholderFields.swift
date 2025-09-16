//
// PlaceholderFields.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct PlaceholderFields<T: CDPlaceholder>: View {
    @ObservedObject var placeholder: T
    @Environment(\.managedObjectContext) private var moc

    @State private var isEditing = false
    @FocusState private var field: EditorField?

    private var headerText: String {
        if placeholder is CDTextField {
            "Text Field"
        } else if placeholder is CDMenu {
            "Menu"
        } else {
            "Checkbox"
        }
    }

    private var headerSymbol: String {
        if placeholder is CDTextField {
            "character.cursor.ibeam"
        } else if placeholder is CDMenu {
            "filemenu.and.selection"
        } else {
            "checkmark.square"
        }
    }

    var body: some View {
        Section {
            LockableTextField(placeholder: placeholder, isEditing: $isEditing, field: $field)

            if !isEditing {
                if let text = placeholder as? CDTextField {
                    TextInputFields(text: text, field: $field)
                } else if let menu = placeholder as? CDMenu {
                    MenuFields(menu: menu)
                } else if let checkbox = placeholder as? CDCheckbox {
                    CheckboxFields(checkbox: checkbox, field: $field)
                }
            }
        } header: {
            PlaceholderHeader(label: headerText, symbol: headerSymbol, onDelete: deletePlaceholder)
        }
        .onAppear(perform: setFocus)
        .onExitCommand(perform: removeFocus)
    }

    private func setFocus() {
        guard placeholder.label.isEmpty else { return }
        isEditing = true
        field = .label
    }

    private func removeFocus() {
        field = nil
    }

    private func deletePlaceholder() {
        guard let template = placeholder.template, let attributedString = template.attributedText else { return }
        let oldTemplate = TemplateProcessor.convertToPlainText(attributedString)
        template.rawText = oldTemplate.replacingOccurrences(of: "◊\(placeholder.label)◊", with: "")
        moc.delete(placeholder)
    }
}

#Preview {
    PlaceholderFields(placeholder: CDPlaceholder())
}
