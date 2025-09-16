//
// FloatingWindowModifier.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct FloatingWindowModifier<WindowContent: View>: ViewModifier {
    @Binding private var isPresented: Bool
    private var title: String?
    private var panel: FloatingWindow<WindowContent>?

    init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        content: WindowContent
    ) {
        self._isPresented = isPresented
        self.title = title
        self.panel = FloatingWindow(
            isPresented: $isPresented,
            title: title,
            content: content)
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { newValue in
                if newValue {
                    present()
                } else {
                    panel?.close()
                }
            }
    }

    private func present() {
        panel?.center()
        panel?.orderFront(nil)
        panel?.makeKey()
    }
}
