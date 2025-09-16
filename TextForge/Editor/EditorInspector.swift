//
// EditorInspector.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct EditorInspector: View {
    init(template: CDTemplate) {
        _placeholders = FetchRequest<CDPlaceholder>(
            sortDescriptors: [SortDescriptor(\.creationDate, order: .forward)],
            predicate: NSPredicate(format: "template = %@", template))
    }

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\CDPlaceholder.creationDate, order: .forward)],
        animation: .default)
    private var placeholders: FetchedResults<CDPlaceholder>

    var body: some View {
        Form {
            ForEach(placeholders) { placeholder in
                PlaceholderFields(placeholder: placeholder)
            }
        }
        .animation(nil, value: placeholders.count)
        .scrollIndicators(.hidden)
        .formStyle(.grouped)
    }
}

#Preview {
    EditorInspector(template: CDTemplate())
}
