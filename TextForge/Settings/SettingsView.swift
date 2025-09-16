//
// SettingsView.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        TabView {
            GeneralSettings()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            supportTab
                .padding()
                .tabItem {
                    Label("Support", systemImage: "bubble.left.and.bubble.right")
                }

            TipJar()
                .padding(.top)
                .tabItem {
                    Label("Tip Jar", systemImage: "hands.clap")
                }

            AppInfo()
                .padding()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }

    private var supportTab: some View {
        VStack {
            Text("Get in touch with any feedback, questions, or feature requests!")
            Button("Contact Support", systemImage: "envelope") {
                openURL(ContactService.emailURL)
            }
        }
    }
}

#Preview {
    SettingsView()
}
