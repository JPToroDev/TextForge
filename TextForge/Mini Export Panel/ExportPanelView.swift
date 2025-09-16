//
// ExportPanelView.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct ExportPanelView: View {
    @State private var renderedTemplate = AttributedString()
    @EnvironmentObject private var template: CDTemplate

    var body: some View {
        VStack(spacing: 0) {
            ExportForm()
                .onAppear { renderedTemplate = TemplateProcessor.render(template) }
                .onChange(of: template) { renderedTemplate = TemplateProcessor.render($0) }

            Divider()
                .foregroundStyle(.gray)

            ExportBottomBar()
                .frame(height: 40)
        }
        .environment(\.renderedTemplate, $renderedTemplate)
    }
}

#Preview {
    ExportPanelView()
}
