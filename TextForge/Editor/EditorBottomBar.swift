//
// EditorBottomBar.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct EditorBottomBar: View {
    init(placeholder: Binding<String?>, template: CDTemplate) {
        self._placeholderToInsert = placeholder
        _placeholders = FetchRequest<CDPlaceholder>(
            sortDescriptors: [SortDescriptor(\.creationDate, order: .forward)],
            predicate: NSPredicate(format: "template = %@ AND label != %@", template, ""))
    }

    @Binding private var placeholderToInsert: String?
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\CDPlaceholder.creationDate, order: .forward)],
        animation: .default)
    private var placeholders: FetchedResults<CDPlaceholder>

    var body: some View {
        HStack {
            Spacer()
            Menu("Insert") {
                ForEach(placeholders) { placeholder in
                    Button(placeholder.label) {
                        updatePlaceholder(placeholder)
                    }
                }
            }
            .fixedSize()
            .disabled(placeholders.isEmpty)
        }
        .padding()
    }

    private func updatePlaceholder(_ placeholder: CDPlaceholder) {
        placeholderToInsert = "◊\(placeholder.label)◊"
    }
}

#Preview {
    EditorBottomBar(placeholder: .constant(nil), template: CDTemplate())
}
