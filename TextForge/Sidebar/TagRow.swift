//
// TagRow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct TagRow: View {
    @Binding var filterTags: Set<CDTag>
    @EnvironmentObject private var tag: CDTag
    @Environment(\.managedObjectContext) private var moc

    @State private var isEditable = false
    @FocusState private var isFocused: Bool

    private var isChecked: Bool {
        filterTags.contains(tag)
    }

    var body: some View {
        Button(action: updateFilterTags) {
            HStack {
                Group {
                    if isEditable {
                        TextField("New Tag", text: $tag.title)
                            .labelsHidden()
                            .focused($isFocused)
                    } else {
                        Text(tag.title)
                    }
                }
                .foregroundStyle(.primary)

                Spacer()

                if isChecked {
                    Image(systemName: "checkmark")
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                }
            }
        }
        .onAppear(perform: setFocus)
        .buttonStyle(.plain)
        .help("Filter templates by this tag")
        .accessibilityElement(children: .contain)
        .onChange(of: isFocused) { isFocused in
            deleteEmptyTags(isFocused)
            isEditable = isFocused
        }
        .contextMenu {
            Button("Rename") {
                isEditable = true
                isFocused = true
            }
            Button("Delete", role: .destructive) {
                moc.delete(tag)
            }
        }
    }

    private func setFocus() {
        guard tag.title.isEmpty else { return }
        isEditable = true
        isFocused = true
    }

    private func updateFilterTags() {
        filterTags.formSymmetricDifference([tag])
    }

    private func deleteEmptyTags(_ value: Bool) {
        guard !value, tag.title.isEmpty else { return }
        moc.delete(tag)
    }
}

#Preview {
    TagRow(filterTags: .constant([]))
}
