//
//  PaletteViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import SwiftUI

final class PaletteViewModel: ObservableObject {
    @Injected var toolManager: DrawingToolManager!
    
    private var colors: [UIColor] = (1...25).map { AppColor.getColor(named: "Palette \($0)") }
    
    lazy var buttonItems: [ToolbarButtonItem<UIColor>] = colors.map { color in
        ToolbarButtonItem(imageType: .circle(color),
                          isSelected: toolManager.selectedColor == color,
                          value: color,
                          onTap: { [weak self] in self?.selectColor(color) })
    }
    
    private func selectColor(_ color: UIColor) {
        toolManager.selectColor(color)
        
        buttonItems.forEach{
            $0.isSelected = $0.value == color
        }
        // TODO: Implement
    }
}

#Preview {
    let colors: [UIColor] = (1...25).map { num in
//            .green
        AppColor.getColor(named: "Palette \(num)")
    }
    
    return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5),
              alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
              spacing: 16) {
        ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
            Image(uiImage: AppImage.circleFilled.withTintColor(color,
                                                         renderingMode: .alwaysTemplate))
                .tint(Color(uiColor: color))
        }
    }
}
