//
// TipJar.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import StoreKit
import SwiftUI

struct TipJar: View {
    @State private var tips = [Product]()
    @State private var totalTips = "$0"

    var body: some View {
        VStack(spacing: 0) {
            Text("""
            Text Forge is made by a team of one,
            so every little bit goes a long way.
            """)
            .fixedSize()
            .multilineTextAlignment(.center)

            tipList
        }
        .onAppear(perform: loadTipData)
    }

    private var tipList: some View {
        Form {
            Section {
                ForEach(tips) { tip in
                    TipRow(tip: tip)
                }
            } footer: {
                HStack {
                    Text("Total: $\(totalTips)")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("Restore Purchases", action: restorePurchases)
                }
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
        .fixedSize(horizontal: false, vertical: true)
    }

    private func restorePurchases() {
        Task {
            try? await AppStore.sync()
        }
    }

    private func loadTipData() {
        tips = Store.shared.products
        totalTips = getTotalTips()
    }

    private func getTotalTips() -> String {
        let purchases = Store.shared.purchasedProducts
        let total = purchases
            .compactMap { Double($0.displayPrice.dropFirst()) }
            .reduce(0, +)
        return String(total)
    }
}
