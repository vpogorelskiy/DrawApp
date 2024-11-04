//
//  ColorsViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import UIKit

final class ColorsViewModel: ObservableObject {
    @Published var isPaletteShown: Bool = false
    
    @Injected var toolManager: DrawingToolManager!
    @Published var isPaletteMenuShown = false
    
    private var colors: [UIColor] = [
        AppColor.white,
        AppColor.red,
        AppColor.black,
        AppColor.blue
    ]
    
    lazy var buttonItems: [ToolbarButtonItem] = {
        [
            .init(image: AppImage.palette,
                  isSelected: isPaletteShown,
                  onTap: { [weak self] in self?.selectPalette() }),
            
        ] + colors.map { color in
            ToolbarButtonItem(image: AppImage.circleFilled(withColor: color),
                              isSelected: toolManager.selectedColor == color,
                              onTap: { [weak self] in self?.selectColor(color) })
        }
    }()
    
    private func selectPalette() {
        // TODO: Implement
    }
    
    private func selectColor(_ color: UIColor) {
        toolManager.selectColor(color)
        // TODO: Implement
    }
}
