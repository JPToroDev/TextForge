//
// Exporter.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct Exporter: View {
    @EnvironmentObject private var template: CDTemplate
    @Environment(\.columnVisibility) private var columnVisibility
    @Environment(\.isShowingEditor) private var isShowingEditor

    @State private var renderedTemplate = AttributedString()

    var body: some View {
        VSplitView {
            ExportForm()

            ZStack {
                DynamicStripes()
                ExportPreview()
            }
        }
        .id(template)
        .environment(\.renderedTemplate, $renderedTemplate)
        .task(id: template) {
            renderedTemplate = TemplateProcessor.render(template)
        }

        Divider()
            .foregroundStyle(.gray)

        ExportBottomBar()
            .frame(height: 50)
            .environment(\.renderedTemplate, $renderedTemplate)
    }
}

#Preview {
    Exporter()
}
