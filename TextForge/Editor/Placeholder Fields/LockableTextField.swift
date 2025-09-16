//
// LockableTextField.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct LockableTextField<T: CDPlaceholder>: View {
    @ObservedObject var placeholder: T
    @Binding var isEditing: Bool
    var field: FocusState<EditorField?>.Binding

    @Environment(\.managedObjectContext) private var moc
    @State private var oldName: String?

    private var lockButtonSymbol: String {
        isEditing ? "arrow.right.circle" : "lock"
    }

    private var lockButtonLabel: String {
        isEditing ? "Update Label" : "Rename Label"
    }

    private var isDisabled: Bool {
        isEditing && placeholder.label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        LabeledContent {
            Button {
                guard !isDisabled else { return }
                updatePlaceholders()
            } label: {
                Image(systemName: lockButtonSymbol)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .disabled(isDisabled)
            .accessibilityLabel(lockButtonLabel)
            .help("Update label")
        } label: {
            contentLabel
        }
        .contentShape(.rect)
        .contextMenu {
            Button("Rename", action: updatePlaceholders)
        }
    }

    @ViewBuilder private var contentLabel: some View {
        if isEditing {
            TextField("Label", text: $placeholder.label, prompt: Text("Label"), axis: .vertical)
                .labelsHidden()
                .focused(field, equals: .label)
                .onSubmit(updatePlaceholders)
        } else {
            Text(placeholder.label)
        }
    }

    private func focusNextField() {
        if let textField = placeholder as? CDTextField, textField.defaultValue.isEmpty {
            Task { field.wrappedValue = .defaultValue }
        } else if let checkbox = placeholder as? CDCheckbox, checkbox.text.isEmpty {
            Task { field.wrappedValue = .text }
        }
    }

    private func updatePlaceholders() {
        isEditing.toggle()
        if isEditing {
            oldName = placeholder.label
            field.wrappedValue = .label
        } else {
            focusNextField()
            TemplateProcessor.regenerateItems(in: placeholder.template!, context: moc)
            guard let oldName else { return }
            let template = placeholder.template!
            let oldTemplate = TemplateProcessor.convertToPlainText(template.attributedText!)
            template.rawText = oldTemplate.replacingOccurrences(of: "◊\(oldName)◊", with: "◊\(placeholder.label)◊")
        }
    }

    private func deletePlaceholder() {
        guard let template = placeholder.template, let attributedString = template.attributedText else { return }
        let oldTemplate = TemplateProcessor.convertToPlainText(attributedString)
        template.rawText = oldTemplate.replacingOccurrences(of: "◊\(placeholder.label)◊", with: "")
        moc.delete(placeholder)
    }
}
