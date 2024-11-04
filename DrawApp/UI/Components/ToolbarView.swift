//
//  ToolbarView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI
import Combine

struct NewToolbarButton: View {
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
