//
// GradientButton.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct GradientButton: View {
    var symbol: String

    var body: some View {
        Image(systemName: symbol)
            .fontWeight(.medium)
            .frame(width: 24, height: 24)
    }
}

#Preview {
    GradientButton(symbol: "plus")
}
