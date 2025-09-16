//
// ExportForm.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct ExportForm: View {
    @EnvironmentObject private var template: CDTemplate
    @Environment(\.isShowingEditor) private var isShowingEditor
    @Environment(\.columnVisibility) private var columnVisibility
    @Environment(\.renderedTemplate) private var renderedTemplate

    var body: some View {
        if template.placeholders.count > 0 {
            inputForm
                .frame(maxWidth: .infinity)
        } else {
            createVariablesButton
        }
    }

    private var inputForm: some View {
        Form {
            ForEach(template.placeholders) { placeholder in
                switch placeholder {
                case let textField as CDTextField:
                    TextFieldRow(textField: textField, onChange: updatePreviewText)
                case let menu as CDMenu:
                    MenuRow(menu: menu, onChange: updatePreviewText)
                case let checkbox as CDCheckbox:
                    CheckboxRow(checkbox: checkbox, onChange: updatePreviewText)
                default: EmptyView()
                }
            }
        }
        .formStyle(.grouped)
        .scrollIndicators(.hidden)
    }

    private var createVariablesButton: some View {
        Button("Create Variables") {
            isShowingEditor.wrappedValue = true
            withAnimation { columnVisibility.wrappedValue = .detailOnly }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func updatePreviewText() {
        renderedTemplate.wrappedValue = TemplateProcessor.render(template)
    }
}

#Preview {
    ExportForm()
}
