//
// ExportPreview.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct ExportPreview: View {
    @EnvironmentObject private var template: CDTemplate
    @Environment(\.renderedTemplate) private var renderedTemplate

    var body: some View {
        if let items = template.items?.allObjects, items.isEmpty {
            Text("This template is blank.")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ScrollView {
                Text(renderedTemplate.wrappedValue)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding()
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    ExportPreview()
}
