//
//  PaletteViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import UIKit

final class PaletteViewModel: ObservableObject {
    @Injected var toolManager: DrawingToolManager!
    
    private var colors: [UIColor] = [
        AppColor.white,
        AppColor.red,
        AppColor.black,
        AppColor.blue
    ]
    
    lazy var buttonItems: [ToolbarButtonItem] = colors.map { color in
        ToolbarButtonItem(image: AppImage.circleFilled(withColor: color),
                          isSelected: toolManager.selectedColor == color,
                          onTap: { [weak self] in self?.selectColor(color) })
    }
    
    private func selectColor(_ color: UIColor) {
        toolManager.selectColor(color)
        // TODO: Implement
    }
}
