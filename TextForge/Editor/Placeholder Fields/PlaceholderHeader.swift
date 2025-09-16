//
// PlaceholderHeader.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct PlaceholderHeader: View {
    var label: String
    var symbol: String
    var onDelete: () -> Void

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Image(systemName: symbol)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
            Spacer()
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "minus.circle")
                    .foregroundStyle(.red)
            }
            .accessibilityLabel("Delete")
            .help("Delete")
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    PlaceholderHeader(label: "String", symbol: "", onDelete: {})
}
