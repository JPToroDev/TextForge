//
// TextFieldRow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct TextFieldRow: View {
    @ObservedObject var textField: CDTextField
    var onChange: () -> Void

    var body: some View {
        TextField(
            textField.label,
            text: $textField.text,
            prompt: Text("My Text"),
            axis: .vertical)
            .onAppear { textField.text = textField.defaultValue }
            .onChange(of: textField.text) { _ in onChange() }
    }
}

#Preview {
    TextFieldRow(textField: CDTextField(), onChange: {})
}
