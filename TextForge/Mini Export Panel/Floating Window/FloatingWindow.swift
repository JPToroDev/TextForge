// 
// FloatingWindow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

class FloatingWindow<Content: View>: NSPanel {
    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>, title: String?, content: Content) {
        self._isPresented = isPresented
        super.init(
            contentRect: .zero,
            styleMask: [
                .resizable,
                .closable,
                .titled,
                .fullSizeContentView,
                .nonactivatingPanel],
            backing: .buffered,
            defer: false)

        self.isFloatingPanel = true
        self.level = .floating
        self.backgroundColor = .clear
        self.isMovableByWindowBackground = true
        self.titlebarAppearsTransparent = true
        self.animationBehavior = .utilityWindow
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        self.contentView = NSHostingView(rootView: content)
        if let title {
            self.title = title
        } else {
            self.titleVisibility = .hidden
        }
    }

    override func close() {
        super.close()
        isPresented = false
    }
}
