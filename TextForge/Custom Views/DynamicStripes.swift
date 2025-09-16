//
// DynamicStripes.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct DynamicStripes: View {
    @Environment(\.colorScheme) private var colorScheme

    private var foregroundColor: Color {
        if colorScheme == .dark {
            .black.opacity(0.2)
        } else {
            .gray.opacity(0.1)
        }
    }

    var body: some View {
        Stripes(foreground: foregroundColor, degrees: 45, barWidth: 2, barSpacing: 2)
    }
}

#Preview {
    DynamicStripes()
}
