//
//  ToolbarView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI
import Combine

struct ToolbarButton: View {
    private let buttonItem: ToolbarButtonItem
    @Environment(\.defaultColor) private var defaultColor: UIColor
    @Environment(\.selectedColor) private var selectedColor: UIColor
    
    private var imageColor: UIColor {
        buttonItem.isSelected ? selectedColor : defaultColor
    }
    
    var body: some View {
        Button(action: { buttonItem.onTap() },
               label: {
            Image(uiImage: buttonItem.image.withRenderingMode(.alwaysTemplate))
                .tint(.init(uiColor: imageColor))
        })
    }
    
    init(buttonItem: ToolbarButtonItem) {
        self.buttonItem = buttonItem
    }
}

final class ToolbarButtonItem: ObservableObject {
    let image: UIImage
    @Published var isSelected: Bool
    let onTap: () -> Void
    
    init(image: UIImage, isSelected: Bool, onTap: @escaping () -> Void) {
        self.image = image
        self.isSelected = isSelected
        self.onTap = onTap
    }
}

// MARK: - selectedColor

struct ToolbarButtonSelectedColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: UIColor = .white
}

// ## Introduce new value to EnvironmentValues
extension EnvironmentValues {
    var selectedColor: UIColor {
        get { self[ToolbarButtonSelectedColorEnvironmentKey.self] }
        set { self[ToolbarButtonSelectedColorEnvironmentKey.self] = newValue }
    }
}

// MARK: - defaultColor

struct ToolbarButtonDefaultColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: UIColor = .white
}

// ## Introduce new value to EnvironmentValues
extension EnvironmentValues {
    var defaultColor: UIColor {
        get { self[ToolbarButtonDefaultColorEnvironmentKey.self] }
        set { self[ToolbarButtonDefaultColorEnvironmentKey.self] = newValue }
    }
}
