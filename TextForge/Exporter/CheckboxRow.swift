//
// CheckboxRow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct CheckboxRow: View {
    @ObservedObject var checkbox: CDCheckbox
    var onChange: () -> Void

    var body: some View {
        Toggle(checkbox.label, isOn: $checkbox.isChecked)
            .onAppear { checkbox.isChecked = checkbox.defaultValue }
            .onChange(of: checkbox.isChecked) { _ in onChange() }
    }
}

#Preview {
    CheckboxRow(checkbox: CDCheckbox(), onChange: {})
}
