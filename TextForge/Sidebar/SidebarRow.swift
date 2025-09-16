//
// SidebarRow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct SidebarRow: View {
    @EnvironmentObject private var template: CDTemplate

    private var templateTitle: String {
        template.title.isEmpty ? "New Template" : template.title
    }

    private var favoriteButtonSymbol: String {
        template.isFavorite ? "star.fill" : "star"
    }

    var body: some View {
        LabeledContent {
            if template.isFavorite {
                Text(Image(systemName: favoriteButtonSymbol))
                    .font(.footnote)
                    .foregroundStyle(.yellow)
            }
        } label: {
            Label(templateTitle, systemImage: "doc.plaintext")
                .lineLimit(1)
        }
    }
}

#Preview {
    SidebarRow()
}
