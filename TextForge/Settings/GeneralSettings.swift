//
// GeneralSettings.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct GeneralSettings: View {
    @AppStorage(.richTextFont) private var defaultFont = K.defaultRichTextFont
    @AppStorage(.richTextFontSize) private var defaultFontSize = 13.0
    @AppStorage(.monospacedFont) private var monospacedFont = K.defaultMonospacedFont
    @Environment(\.openURL) private var openURL

    @State private var fontFamilies = [String]()
    @FocusState private var isFocused: Bool

    private let fontFooterText = """
    Text Forge will use these defaults when exporting your writing as rich text.
    """

    var body: some View {
        Form {
            LabeledContent {
                Button("Keyboard Settings", action: openKeyboardSettings)
            } label: {
                Text("Enable Keyboard Navigation")
                Text("Navigate through forms with Tab and Shift Tab.")
            }

            Section {
                Picker("Rich Text Font", selection: $defaultFont) {
                    ForEach(fontFamilies, id: \.self) { font in
                        Text(font.description)
                    }
                }
                Picker("Monospaced Font", selection: $monospacedFont) {
                    ForEach(fontFamilies, id: \.self) { font in
                        Text(font.description)
                    }
                }
                Stepper("Default Font Size", value: $defaultFontSize, format: .number)
                    .focused($isFocused)
                    .onSubmit { isFocused = false }
                    .onExitCommand { isFocused = false }
            } footer: {
                Text(fontFooterText)
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
        .fixedSize(horizontal: false, vertical: true)
        .task {
            let fontManager = NSFontManager.shared
            fontFamilies = fontManager.availableFontFamilies
        }
    }

    private func openKeyboardSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension") {
            openURL(url)
        }
    }
}
