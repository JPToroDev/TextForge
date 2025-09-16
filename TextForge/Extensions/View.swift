// 
// View.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2025 J.P. Toro
//

import SwiftUI

extension View {
    func animationDisabled() -> some View {
        self.transaction { transaction in
            transaction.animation = nil
        }
    }
}

extension View {
    func floatingWindow<Content: View>(
        _ title: String? = nil,
        isPresented: Binding<Bool>,
        content: () -> Content
    ) -> some View {
        modifier(FloatingWindowModifier(isPresented: isPresented, title: title, content: content()))
    }
}
