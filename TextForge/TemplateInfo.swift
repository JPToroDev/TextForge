//
// TemplateInfo.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct TemplateInfo: View {
    private enum InfoField {
        case title, description
    }

    @EnvironmentObject private var template: CDTemplate
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss

    @State private var isSelected = false
    @FocusState private var field: InfoField?

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\CDTag.title, order: .forward)],
        animation: .default)
    private var tags: FetchedResults<CDTag>

    var onSubmit: (() -> Void)?

    private var templateTags: [CDTag] {
        template.tags?.allObjects as? [CDTag] ?? []
    }

    var body: some View {
        VStack(spacing: 10) {
            TextField("Template Title", text: $template.title, prompt: Text("Title"))
                .labelsHidden()
                .textFieldStyle(.roundedBorder)
                .focused($field, equals: .title)
                .padding([.top, .horizontal])

            TextField(
                "Template Description",
                text: $template.detail,
                prompt: Text("A description about this template..."),
                axis: .vertical)
                .labelsHidden()
                .textFieldStyle(.roundedBorder)
                .focused($field, equals: .description)
                .padding(.horizontal)

            tagEditor
                .frame(height: 22)
                .padding(.horizontal)

            Divider()

            bottomBar
                .padding(.bottom, 10)
                .padding(.horizontal)
        }
        .frame(width: 500)
        .onExitCommand { field = nil }
    }

    private var tagEditor: some View {
        HStack {
            Menu("Add Tag") {
                ForEach(tags.filter { !templateTags.contains($0) }) { tag in
                    Button(tag.title) {
                        template.addToTags(tag)
                    }
                }
            }
            .fixedSize()
            .disabled(tags.allSatisfy(templateTags.contains))

            Spacer()

            ForEach(templateTags) { tag in
                Button {
                    template.removeFromTags(tag)
                } label: {
                    tagButtonLabel(tag.title)
                }
                .buttonStyle(ToolbarButtonStyle())
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button("Toggle Favorite", systemImage: "star") {
                template.isFavorite.toggle()
            }
            .labelStyle(.iconOnly)
            .symbolVariant(template.isFavorite ? .fill : .none)
            .buttonStyle(.plain)
            .foregroundStyle(.yellow)
            .fontWeight(.medium)

            Spacer()

            if template.objectID.isTemporaryID {
                Button("Cancel", action: cancel)
            }

            Button("Done", action: done)
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .disabled(template.title.isEmpty ? true : false)
        }
    }

    private func tagButtonLabel(_ text: String) -> some View {
        HStack(alignment: .center, spacing: 2) {
            Text(text)
                .padding(.bottom, 1)
            Image(systemName: "xmark")
                .font(.system(size: 8))
                .fontWeight(.bold)
        }
        .padding(.vertical, -3)
    }

    private func cancel() {
        moc.delete(template)
        dismiss()
    }

    private func done() {
        onSubmit?()
        CoreDataManager.save(context: moc)
        dismiss()
    }
}

#Preview {
    TemplateInfo()
}
