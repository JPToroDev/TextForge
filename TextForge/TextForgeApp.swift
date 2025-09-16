//
// TextForgeApp.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

@main
struct TextForgeApp: App {
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var isShowingMiniExporter = false
    @FocusedObject private var selection: CDTemplate?

    private let viewContext = PersistenceController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.columnVisibility, $columnVisibility)
                .environment(\.managedObjectContext, viewContext)
                .onAppear(perform: Store.initialize)
                .floatingWindow(selection?.title, isPresented: $isShowingMiniExporter) {
                    miniExportWindow
                        .frame(minWidth: 300, minHeight: 100)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(.regularMaterial)
                        .environment(\.managedObjectContext, viewContext)
                }
        }
        .commands {
            mainMenuCommands
            helpMenuCommands
            viewMenuCommands
        }

        Settings {
            SettingsView()
                .frame(width: 450)
        }
    }

    @ViewBuilder private var miniExportWindow: some View {
        if let selection, !selection.placeholders.isEmpty {
            ExportPanelView()
                .environmentObject(selection)
                .scrollBounceBehavior(.basedOnSize)
        } else {
            Text("This template doesn’t have any fields.")
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var mainMenuCommands: some Commands {
        CommandGroup(before: .systemServices) {
            Link("Rate on App Store...", destination: URL(string: "https://apple.com")!)
        }
    }

    private var helpMenuCommands: some Commands {
        CommandGroup(replacing: .help) {
            Link("Email Support", destination: ContactService.emailURL)
            Divider()
            Link("Follow on Mastodon", destination: ContactService.mastodonURL)
        }
    }

    private var viewMenuCommands: some Commands {
        let miniExporterToggleText = isShowingMiniExporter ? "Hide Mini Exporter" : "Show Mini Exporter"
        let sidebarTogglerText = columnVisibility != .detailOnly ? "Hide Sidebar" : "Show Sidebar"

        return CommandGroup(after: .sidebar) {
            Toggle(miniExporterToggleText, systemImage: "macwindow", isOn: $isShowingMiniExporter)
                .disabled(selection == nil)
                .keyboardShortcut("g")
            Divider()
            Button(sidebarTogglerText, action: toggleSidebar)
                .keyboardShortcut("d")
        }
    }

    private func toggleSidebar() {
        withAnimation {
            columnVisibility = (columnVisibility != .detailOnly) ? .detailOnly : .all
        }
    }
}
