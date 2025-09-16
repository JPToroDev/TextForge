//
// Stripes.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct Stripes: View {
    var background = Color.clear
    var foreground = Color.pink.opacity(0.8)
    var degrees = 30.0
    var barWidth = 20.0
    var barSpacing = 20.0

    var body: some View {
        GeometryReader { geometry in
            let longSide = max(geometry.size.width, geometry.size.height)
            let itemWidth = barWidth + barSpacing
            let items = Int(2 * longSide / itemWidth)

            HStack(spacing: barSpacing) {
                ForEach(0 ..< items, id: \.self) { _ in
                    foreground
                        .frame(width: barWidth, height: 2 * longSide)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .rotationEffect(Angle(degrees: degrees), anchor: .center)
            .offset(x: -longSide / 2, y: -longSide / 2)
            .background(background)
        }
        .clipped()
    }
}
