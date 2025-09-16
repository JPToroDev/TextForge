//
// Sidebar.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct Sidebar: View {
    @Binding var selection: CDTemplate?
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.columnVisibility) private var columnVisibility
    @Environment(\.isShowingEditor) private var isShowingEditor

    @State private var filterTags = Set<CDTag>()
    @State private var isShowingFilterPane = false
    @State private var inspectedTemplate: CDTemplate?
    @FocusState private var isFocused: Bool

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\CDTemplate.order, order: .forward)],
        animation: .default)
    private var templates: FetchedResults<CDTemplate>

    private var filterButtonSymbol: String {
        filterTags.count > 0 ? "line.3.horizontal.decrease.circle.fill" : "tag"
    }

    var body: some View {
        List(selection: $selection) {
            ForEach(templates, id: \.self) { template in
                SidebarRow()
                    .environmentObject(template)
                    .accessibilityLabel(listRowLabel(from: template))
                    .accessibilityRemoveTraits(.isButton)
                    .contextMenu {
                        Button("Rename") {
                            inspectedTemplate = template
                        }
                        Button(template.isFavorite ? "Unfavorite" : "Favorite") {
                            template.isFavorite.toggle()
                        }
                        Button("Delete", role: .destructive) {
                            withAnimation { delete(template) }
                        }
                    }
            }
            .onMove { indexSet, offset in
                CoreDataManager.move(items: Array(templates), from: indexSet, to: offset)
            }
        }
        .focusedObject(selection)
        .onExitCommand(perform: clearSelection)
        .scrollIndicators(.hidden)
        .accessibilityLabel("Templates List")
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if #available(macOS 26, *) {
                bottomBar
                    .frame(height: 35, alignment: .center)
                    .glassEffect(.regular, in: .rect(cornerRadius: 14, style: .continuous))
                    .padding(5)
            } else {
                bottomBar
                    .frame(height: 51, alignment: .center)
                    .background(.bar, ignoresSafeAreaEdges: .bottom)
                    .overlay(alignment: .top) {
                        Divider()
                            .foregroundStyle(.gray)
                    }
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button("Add", systemImage: "plus", action: inspectTemplate)
                .labelStyle(.iconOnly)
                .frame(width: 20, height: 20)
                .keyboardShortcut("n")
                .accessibilityLabel("New Template")
                .help("Create a template")
                .sheet(item: $inspectedTemplate) { template in
                    TemplateInfo {
                        if template.objectID.isTemporaryID {
                            selection = templates.last
                            isShowingEditor.wrappedValue = true
                            withAnimation { columnVisibility.wrappedValue = .detailOnly }
                        }
                    }
                    .environmentObject(template)
                }

            Spacer()

            Button("Show Filter Pane", systemImage: filterButtonSymbol) {
                isShowingFilterPane.toggle()
            }
            .foregroundStyle(filterTags.count > 0 ? .accent : .primary)
            .animation(.spring, value: filterTags.count)
            .frame(width: 20, height: 20)
            .accessibilityLabel("Tags")
            .help("Open the tags popover")
            .popover(isPresented: $isShowingFilterPane) {
                FilterPane(filterTags: $filterTags)
                    .onDisappear { CoreDataManager.save(context: moc) }
                    .frame(width: 150, height: 300)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .onChange(of: filterTags.count) { _ in
            withAnimation { filterTemplates() }
        }
    }

    private func inspectTemplate() {
        inspectedTemplate = CoreDataManager.createTemplate(order: templates.count, context: moc)
    }

    private func delete(_ template: CDTemplate) {
        clearSelection()
        moc.delete(template)
    }

    private func clearSelection() {
        selection = nil
    }

    private func filterTemplates() {
        if filterTags.count > 0 {
            templates.nsPredicate = NSPredicate(format: "ANY tags IN %@", filterTags)
        } else {
            templates.nsPredicate = nil
        }
    }

    private func listRowLabel(from template: CDTemplate) -> String {
        var label = template.title
        guard !template.detail.isEmpty else { return label }
        label += ", \(template.detail)"
        return label
    }
}

#Preview {
    Sidebar(selection: .constant(nil))
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(@ViewBuilder _ transform: (Self) -> Content) -> some View {
        transform(self)
    }
}
