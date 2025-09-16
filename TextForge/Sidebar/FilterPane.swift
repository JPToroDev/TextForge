//
// FilterPane.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct FilterPane: View {
    @Binding var filterTags: Set<CDTag>
    @Environment(\.managedObjectContext) private var moc

    @State private var selection: CDTag?

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\CDTag.creationDate, order: .forward)],
        animation: .default)
    private var tags: FetchedResults<CDTag>

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Tags")
                    .fontWeight(.medium)
                    .accessibilityHidden(true)
                Spacer()
                Button("Add Tag", systemImage: "plus") {
                    CoreDataManager.createTag(order: tags.count, context: moc)
                }
                .labelStyle(.iconOnly)
                .fontWeight(.semibold)
            }
            .foregroundStyle(.secondary)
            .padding(.vertical, 8)
            .padding(.leading)
            .padding(.trailing, 15)
            .buttonStyle(.plain)

            Divider()

            List(tags, id: \.self) { tag in
                TagRow(filterTags: $filterTags)
                    .listRowSeparator(.hidden)
                    .environmentObject(tag)
            }
            .scrollContentBackground(.hidden)
            .onExitCommand { clearSelection() }
            .onDeleteCommand { deleteTag() }
        }
    }

    private func deleteTag() {
        guard let tag = selection else { return }
        filterTags.remove(tag)
        moc.delete(tag)
    }

    private func clearSelection() {
        selection = nil
    }
}

#Preview {
    FilterPane(filterTags: .constant([]))
}
