//
// TipRow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import StoreKit
import SwiftUI

struct TipRow: View {
    @State private var isPurchased = false
    @State private var error: StoreError?
    @State private var isShowingError = false

    let tip: Product

    var body: some View {
        LabeledContent(tip.displayName) {
            if isPurchased {
                Text("Sent 🎉")
            } else {
                Button(tip.displayPrice, action: buy)
            }
        }
        .animation(.default, value: isPurchased)
        .alert(isPresented: $isShowingError, error: error) {}
        .onAppear {
            isPurchased = (try? Store.shared.isPurchased(tip)) ?? false
        }
    }

    private func buy() {
        Task {
            do {
                isPurchased = try await Store.shared.purchase(tip) != nil
            } catch StoreError.failedVerification {
                self.error = error
                isShowingError = true
            } catch {
                self.error = .other(error.localizedDescription)
                isShowingError = true
            }
        }
    }
}
