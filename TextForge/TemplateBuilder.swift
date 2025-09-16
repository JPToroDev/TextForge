//
// TemplateBuilder.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct TemplateBuilder: View {
    @EnvironmentObject private var template: CDTemplate
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.columnVisibility) private var columnVisibility
    @Environment(\.isShowingEditor) private var isShowingEditor

    @State private var isShowingTemplateInfo = false

    var body: some View {
        VStack(spacing: 0) {
            Group {
                if isShowingEditor.wrappedValue {
                    Editor()
                } else {
                    Exporter()
                }
            }
            .animationDisabled()
            .transition(.opacity)
        }
        .toolbar {
            showTemplateInfoButton
            if isShowingEditor.wrappedValue {
                addPlaceholderMenu
            }
            toggleEditorButton
        }
        .navigationTitle($template.title)
        .navigationSubtitle(template.detail)
        .sheet(isPresented: $isShowingTemplateInfo) {
            TemplateInfo()
        }
    }

    private var showTemplateInfoButton: some View {
        Button("Show Info", systemImage: "info.circle") {
            isShowingTemplateInfo = true
        }
        .labelStyle(.iconOnly)
    }

    private var toggleEditorButton: some View {
        Button(action: toggleEditorVisibility) {
            if isShowingEditor.wrappedValue {
                Text("Done")
            } else {
                Image(systemName: "slider.horizontal.3")
            }
        }
        .animationDisabled()
        .keyboardShortcut("e")
    }

    private var addPlaceholderMenu: some View {
        Menu("Add Placeholder", systemImage: "plus") {
            Button("Add Text Field") {
                CoreDataManager.createPlaceholder(
                    type: CDTextField.self,
                    template: template,
                    context: moc)
            }
            Button("Add Menu") {
                CoreDataManager.createPlaceholder(
                    type: CDMenu.self,
                    template: template,
                    context: moc)
            }
            Button("Add Checkbox") {
                CoreDataManager.createPlaceholder(
                    type: CDCheckbox.self,
                    template: template,
                    context: moc)
            }
        }
        .animationDisabled()
        .labelStyle(.iconOnly)
        .help("Add a variable")
    }

    private func toggleEditorVisibility() {
        withAnimation {
            isShowingEditor.wrappedValue.toggle()
            if isShowingEditor.wrappedValue {
                columnVisibility.wrappedValue = .detailOnly
            } else {
                TemplateProcessor.regenerateItems(in: template, context: moc)
                columnVisibility.wrappedValue = .all
            }
        }
    }
}

#Preview {
    TemplateBuilder()
}
