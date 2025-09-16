//
// Editor.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct Editor: View {
    @EnvironmentObject private var template: CDTemplate
    @Environment(\.managedObjectContext) private var moc

    @State private var placeholder: String?

    var body: some View {
        HSplitView {
            VStack(spacing: 0) {
                ZStack {
                    DynamicStripes()
                    EditorTextView(template: template, placeholderCode: $placeholder)
                        .id(template.rawText)
                }

                Divider()
                    .foregroundStyle(.gray)

                EditorBottomBar(placeholder: $placeholder, template: template)
                    .frame(height: 50)
            }
            .layoutPriority(1)

            EditorInspector(template: template)
                .frame(minWidth: 250, idealWidth: 300, maxWidth: 400)
                .layoutPriority(0)
        }
        .onAppear { template.rawText = TemplateProcessor.generateRawText(template) }
        .onChange(of: template) { [template] newTemplate in
            TemplateProcessor.regenerateItems(in: template, context: moc)
            newTemplate.rawText = TemplateProcessor.generateRawText(newTemplate)
        }
    }
}

#Preview {
    Editor()
}
