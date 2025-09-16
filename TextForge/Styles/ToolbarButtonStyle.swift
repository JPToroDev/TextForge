//
// ToolbarButtonStyle.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct ToolbarButtonStyle: ButtonStyle {
    @State private var isOverButton = false
    private let hoverBackgroundColor = Color.gray.opacity(0.2)
    private let pressedBackgroundColor = Color.gray.opacity(0.3)
    private let cornerRadius = 6.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .foregroundStyle(configuration.isPressed ? .primary : .secondary)
            .background(isOverButton ? hoverBackgroundColor : .clear)
            .background(configuration.isPressed ? pressedBackgroundColor : .clear)
            .cornerRadius(cornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(hoverBackgroundColor, lineWidth: 1)
            }
            .onHover { isOver in
                self.isOverButton = isOver
            }
    }
}
