//
// TextInputFields.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

enum EditorField {
    case label, defaultValue, text
}

struct TextInputFields: View {
    @ObservedObject var text: CDTextField
    var field: FocusState<EditorField?>.Binding

    var body: some View {
        TextField(
            "Default Value",
            text: $text.defaultValue,
            prompt: Text("Default Value"),
            axis: .vertical)
            .labelsHidden()
            .focused(field, equals: .defaultValue)
            .onSubmit { field.wrappedValue = nil }
    }
}
