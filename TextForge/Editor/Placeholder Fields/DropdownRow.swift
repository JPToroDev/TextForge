//
// SelectionRow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct DropdownRow: View {
    @ObservedObject var option: CDMenuOption

    var body: some View {
        TextField("Option", text: $option.text, prompt: Text("Option \(option.order + 1)"), axis: .vertical)
            .lineLimit(1...)
            .labelsHidden()
    }
}

#Preview {
    DropdownRow(option: CDMenuOption())
}
