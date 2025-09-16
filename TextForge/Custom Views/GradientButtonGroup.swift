//
// GradientButtonGroup.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct GradientButtonGroup<T: Any>: View {
    @Binding var selection: T?
    var itemType = "tag"
    var leftButtonSymbol = "plus"
    var rightButtonSymbol = "minus"
    var leftButtonAction: () -> Void
    var rightButtonAction: () -> Void

    private var createButtonLabel: String {
        "New \(itemType.capitalized)"
    }

    private var createButtonHint: String {
        "Create a \(itemType)"
    }

    var body: some View {
        HStack(spacing: 0) {
            Button(action: leftButtonAction) {
                GradientButton(symbol: leftButtonSymbol)
            }
            .accessibilityLabel(createButtonLabel)
            .help(createButtonHint)

            Divider()
                .frame(height: 16)

            Button(role: .destructive, action: rightButtonAction) {
                GradientButton(symbol: rightButtonSymbol)
            }
            .disabled(selection == nil ? true : false)
            .accessibilityLabel("Delete")
            .help("Delete")
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    GradientButtonGroup(
        selection: .constant(NSManagedObject()),
        leftButtonAction: {},
        rightButtonAction: {})
}
