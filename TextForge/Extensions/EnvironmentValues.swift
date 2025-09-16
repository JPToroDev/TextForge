// 
// EnvironmentValues.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

extension EnvironmentValues {
    @Entry var columnVisibility: Binding<NavigationSplitViewVisibility> = .constant(.all)
    @Entry var isShowingEditor: Binding<Bool> = .constant(false)
    @Entry var renderedTemplate: Binding<AttributedString> = .constant("")
}
