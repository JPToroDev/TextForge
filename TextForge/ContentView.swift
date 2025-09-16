//
// ContentView.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.columnVisibility) private var columnVisibility

    @State private var selection: CDTemplate?
    @State private var isShowingEditor = false

    var body: some View {
        NavigationSplitView(columnVisibility: columnVisibility) {
            Sidebar(selection: $selection)
                .navigationSplitViewColumnWidth(min: 150, ideal: 200, max: 250)
        } detail: {
            splitViewContent
                .frame(minWidth: 300)
        }
        .navigationSplitViewStyle(.prominentDetail)
        .environment(\.isShowingEditor, $isShowingEditor)
    }

    @ViewBuilder private var splitViewContent: some View {
        if let template = selection {
            TemplateBuilder()
                .environmentObject(template)
        } else {
            Text("No Template Selected")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
