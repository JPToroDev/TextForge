//
// MenuRow.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct MenuRow: View {
    init(menu: CDMenu, onChange: @escaping () -> Void) {
        self.menu = menu
        self.onChange = onChange
        _options = FetchRequest<CDMenuOption>(
            sortDescriptors: [SortDescriptor(\.order, order: .forward)],
            predicate: NSPredicate(format: "menu = %@", menu))
    }

    @ObservedObject private var menu: CDMenu
    private var onChange: () -> Void

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\CDMenuOption.order, order: .forward)],
        animation: .default)
    private var options: FetchedResults<CDMenuOption>

    var body: some View {
        Picker(menu.label, selection: $menu.selection) {
            ForEach(options) { option in
                Text(option.text)
                    .tag(option.order)
            }
        }
        .onAppear { menu.selection = 0 }
        .onChange(of: menu.selection) { _ in onChange() }
    }
}

#Preview {
    MenuRow(menu: CDMenu(), onChange: {})
}
