//
// DropdownFields.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI
import UniformTypeIdentifiers

struct MenuFields: View {
    private enum Focusable: Hashable {
        case none
        case row(id: CDMenuOption.ID)
    }

    init(menu: CDMenu) {
        self.menu = menu
        _options = FetchRequest<CDMenuOption>(
            sortDescriptors: [SortDescriptor(\.order, order: .forward)],
            predicate: NSPredicate(format: "menu = %@", menu))
    }

    @ObservedObject var menu: CDMenu
    @Environment(\.managedObjectContext) private var moc

    @State private var selection: CDMenuOption.ID?
    @FocusState private var field: EditorField?
    @FocusState private var focusedOption: Focusable?

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\CDMenuOption.order, order: .forward)],
        animation: .default)
    private var options: FetchedResults<CDMenuOption>

    var body: some View {
        Table(of: CDMenuOption.self, selection: $selection) {
            TableColumn("Menu Options") { option in
                DropdownRow(option: option)
                    .focused($focusedOption, equals: .row(id: option.id))
                    .onAppear { setFocus(for: option) }
            }
        } rows: {
            ForEach(options) { option in
                TableRow(option)
                    .itemProvider {
                        NSItemProvider(contentsOf: option.objectID.uriRepresentation())!
                    }
            }
            .onInsert(of: [UTType.url], perform: onInsert)
        }
        .contextMenu(forSelectionType: CDMenuOption.ID.self) { items in
            Button("Edit") { focus(items) }
        } primaryAction: { items in
            focus(items)
        }
        .onExitCommand { selection = nil }
        .padding(.bottom, 24)
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                GradientButtonGroup(selection: $selection, itemType: "menu option") {
                    createMenuOption()
                } rightButtonAction: {
                    deleteMenuOption()
                }
            }
            .background(Rectangle().opacity(0.04))
        }
    }

    private func setFocus(for option: CDMenuOption) {
        guard option.text.isEmpty else { return }
        focusedOption = .row(id: option.id as CDMenuOption.ID)
    }

    private func focus(_ options: Set<CDMenuOption.ID>) {
        guard let selection = options.first else { return }
        focusedOption = .row(id: selection)
    }

    private func deleteMenuOption() {
        guard let option = menu.orderedOptions.first(where: { $0.id == selection }) else { return }
        moc.delete(option)
    }

    private func createMenuOption() {
        // Orders maybe be nonconsecutive if options were deleted
        for (index, option) in menu.orderedOptions.enumerated() {
            option.order = index
        }
        let order = menu.options?.count ?? 0
        CoreDataManager.createMenuOption(menu: menu, order: order, context: moc)
    }

    private func onInsert(at offset: Int, itemProvider: [NSItemProvider]) {
        for provider in itemProvider where provider.canLoadObject(ofClass: URL.self) {
            _ = provider.loadObject(ofClass: URL.self) { url, _ in
                Task { @MainActor in
                    if let url,
                       let objectID = moc.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url),
                       let option = moc.object(with: objectID) as? CDMenuOption {
                        move(from: [option.order], to: offset)
                    }
                }
            }
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        var revisedItems: [CDMenuOption] = Array(options)
        let lastIndex = options.count
        let correctedDestination = destination > source.first! && destination != lastIndex ?
            destination + 1 : destination
        revisedItems.move(fromOffsets: source, toOffset: correctedDestination)

        for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            revisedItems[reverseIndex].order = reverseIndex
        }
    }
}

#Preview {
    MenuFields(menu: CDMenu())
}
