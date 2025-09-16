//
// CheckboxFields.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct CheckboxFields: View {
    @ObservedObject var checkbox: CDCheckbox
    var field: FocusState<EditorField?>.Binding

    var body: some View {
        TextField(
            "Text",
            text: $checkbox.text,
            prompt: Text("An epic paragraph that only some folks will read..."),
            axis: .vertical)
            .labelsHidden()
            .focused(field, equals: .text)

        LabeledContent("Default Value") {
            Toggle("Included", isOn: $checkbox.defaultValue)
                .toggleStyle(.checkbox)
                .labelsHidden()
                .help("Include text")
        }
    }
}
